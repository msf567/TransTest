using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.UI;

using System.Runtime.InteropServices;
public class MacOSHookTest : MonoBehaviour
{

#if UNITY_STANDALONE_OSX
    [DllImport("MacHook")]
    private static extern IntPtr _sayHiToUnity();

    [DllImport("MacHook")]
    private static extern IntPtr _initializeTransparent();

    [DllImport("MacHook")]
    private static extern void workingtransparent();

    [DllImport("MacHook")]
    private static extern IntPtr _transparency();
#endif

    [RuntimeInitializeOnLoadMethod]
    void Load()
    {
#if !UNITY_EDITOR
        workingtransparent();
     //   GetComponent<Text>().text = Marshal.PtrToStringAuto(_initializeTransparent());
#endif
    }

    void Update()
    {
        if(Input.GetKeyDown("q"))
        {
            workingtransparent();
            //<Text>().text = "q " +  Marshal.PtrToStringAuto(_initializeTransparent());

        } 
    }
}
