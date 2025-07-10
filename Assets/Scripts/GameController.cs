using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

public class GameController : MonoBehaviour
{
    [SerializeField] Rigidbody playerRb;
    [SerializeField] Transform playerModel;

    [NonSerialized] public bool isFishing = false;


    private Vector3 _mousePos;
    private Vector3 direction;
    private float sign;
    

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(!isFishing)
            Inputs();

        if (playerRb.velocity.magnitude > 10f)
            playerRb.velocity = playerRb.velocity.normalized * 10f;
    }

    void Inputs()
    {
        if(Input.GetMouseButton(0))
        {
            _mousePos = Input.mousePosition - new Vector3(Screen.width/2,Screen.height/2,0f);
            //Debug.Log(_mousePos.normalized);
            direction = new Vector3(_mousePos.normalized.x, 0f, _mousePos.normalized.y);
            sign = (direction.x >= 0) ? 1 : -1;

            playerRb.AddForce(direction * Time.deltaTime * 500f);
            playerModel.eulerAngles = new Vector3(0,Vector3.Angle(Vector3.forward,direction) * sign,0);
        }
    }
}
