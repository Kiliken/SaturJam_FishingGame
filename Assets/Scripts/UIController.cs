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
    }

    void MinigameLoop()
    {
        // loop the minigame
    }
}
