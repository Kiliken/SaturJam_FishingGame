using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIController : MonoBehaviour
{
    [NonSerialized] public bool canFish = false;

    [SerializeField] GameObject fishButton;
    [SerializeField] GameObject minigameScreen;
    [SerializeField] GameController controller;
    [SerializeField] GameObject minigameCursor;
    [SerializeField] GameObject minigameHitbox;
    [SerializeField] GameObject catchDisplay;

    [NonSerialized] public Transform currentHotspot;

    int pullCount = 0;
    int toPull = 1;

    float showFish = 0f;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        fishButton.SetActive(canFish && !controller.isFishing);

        if (controller.isFishing)
            MinigameLoop();

        if (showFish > 0f)
        {
            showFish -= Time.deltaTime;
            catchDisplay.SetActive(true);
            catchDisplay.GetComponent<RectTransform>().sizeDelta = new Vector3(500f + MathF.Sin(Time.time * 3f) * 100, 500f + MathF.Sin(Time.time * 3f) * 100f, 0f);

        }else catchDisplay.SetActive(false);
    }

    public void Fish()
    {
        StartMinigame();
        controller.isFishing = true;
        
    }

    void StartMinigame()
    {
        //reset and start minigame
        minigameScreen.SetActive(true);
        minigameHitbox.transform.localPosition = new Vector3(UnityEngine.Random.Range(-550f, 550f),250f,0f);
        pullCount = 0;
        toPull = UnityEngine.Random.Range(1, 6);
    }

    void MinigameLoop()
    {
        // loop the minigame
        minigameCursor.transform.localPosition = new Vector3(Mathf.Sin(Time.time * 2) * 550, 250f, 0f);
    }

    public void MinigameCatch()
    {
        if (minigameHitbox.transform.localPosition.x - 100f < minigameCursor.transform.localPosition.x && minigameHitbox.transform.localPosition.x + 100f > minigameCursor.transform.localPosition.x)
        {
            pullCount++;
            if(pullCount < toPull)
            {
                minigameHitbox.transform.localPosition = new Vector3(UnityEngine.Random.Range(-550f, 550f), 250f, 0f);

                return;
            }

            Debug.Log("CATCH");
            Destroy(currentHotspot.gameObject);
            controller.hotSpotFlag = 0x01;
            canFish = false;
            minigameScreen.SetActive(false);
            controller.isFishing = false;
            showFish = 5.0f;
        }
    }
}
