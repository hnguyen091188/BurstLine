using UnityEngine;
using System.Collections;

public class Blades : Weapon {
	public override void execute(){
		//this.animation ["BladeOpen"].wrapMode = WrapMode.ClampForever;
		networkView.RPC("playAnimation",RPCMode.All,"BladeOpen");
		//this.animation.CrossFade ("BladeOpen");
		BladeProjectile[] script;
		//find bladeprojectile script
		script = this.GetComponentsInChildren<BladeProjectile>();
		//Debug.Log(script.Length);
		foreach(BladeProjectile e in script){
			e.enabled = true;
			assignToPrefab(this,e);
		}
	}

	[RPC]
	void playAnimation(string name){
		this.animation.CrossFade(name);
	
	}
}
