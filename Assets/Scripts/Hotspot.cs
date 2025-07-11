using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hotspot : MonoBehaviour
{
    UIController uiController;

    private void Start()
    {
        uiController = GameObject.FindAnyObjectByType<UIController>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            uiController.canFish = true;
            uiController.currentHotspot = this.transform;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            uiController.canFish = false;
            uiController.currentHotspot = null;
        }
    }
}
