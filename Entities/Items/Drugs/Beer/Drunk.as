#include "Knocked.as";

void onInit(CBlob@ this)
{
	this.addCommandID("consume");
}

void onTick(CBlob@ this)
{
	if (this.hasTag("dead")) return;
	u8 level = this.get_u8("drunk");
	
	if (!this.hasTag("radaway"))
	{
		this.Tag("radaway");
	}
	
	if (this.get_u32("next sober") < getGameTime() && XORRandom(1000) == 0)
	{
		this.set_u8("drunk", Maths::Max(this.get_u8("drunk") - 1, 0));
	}
	/*
	if (level > 0 && getKnocked(this) < 10 && XORRandom(1000 / (1 + level * 1.5f)) == 0)
	{
		u8 knock = 5 + XORRandom(20) * level;
	
		SetKnocked(this, knock);
		this.getSprite().PlaySound("drunk_fx" + XORRandom(5), 0.8f, this.getSexNum() == 0 ? 1.0f : 2.0f);
	}*/
	
	if (getNet().isClient())
	{
		if (this.isMyPlayer())
		{
			f32 rot;
			rot += Maths::Sin(getGameTime() / 30.0f) * level * 0.3f;
			rot += Maths::Cos(getGameTime() / 25.0f) * level * 0.3f;
			rot += Maths::Sin(380 + getGameTime() / 40.0f) * level * 0.4f;
			
			CCamera@ cam = getCamera();
			cam.setRotation(rot);
		}
	}
	
	
	if (level == 0)
	{
	if (this.hasTag("radaway"))
	{
		this.Untag("radaway");
	}
		print("sober");
	
		this.getCurrentScript().runFlags |= Script::remove_after_this;
		
		if (getNet().isClient() && this.isMyPlayer())
		{
			CCamera@ cam = getCamera();
			cam.setRotation(0);
		}
	}
}

void onDie(CBlob@ this)
{
	if (getNet().isClient() && this.isMyPlayer())
	{
		CCamera@ cam = getCamera();
		cam.setRotation(0);
	}
	if (this != null && this.hasTag("radaway"))
	{
		this.Untag("radaway");
	}

	this.set_u8("drunk", 0);

	
	// print("die");
}
/*
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	f32 modifier = Maths::Max(0.3f, Maths::Min(1, Maths::Pow(0.80f, this.get_u8("drunk"))));
	// print("" + modifier);
	return damage * modifier;
}*/