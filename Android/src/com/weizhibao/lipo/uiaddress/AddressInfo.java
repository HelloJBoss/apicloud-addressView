package com.weizhibao.lipo.uiaddress;

import java.io.Serializable;
import org.json.JSONArray;
import org.json.JSONObject;
/**
 * 地址类
 * @author lipo(879736112)
 * gan shi jian, mei you zuo zhu jie
 */
public class AddressInfo implements Serializable {
	private static final long serialVersionUID = 1L;
	public int id;
	public String name;
	public int hasChild;
	public JSONArray sub;

	public AddressInfo() {
	}

	public AddressInfo(int id, String name) {
		this.id = id;
		this.name = name;
	}

	public static AddressInfo fromJson(JSONObject json) {
		AddressInfo address = new AddressInfo();

		address.id = json.optInt("id");
		address.name = json.optString("name");

		if (!json.isNull("sub")) {
			address.sub = json.optJSONArray("sub");
			int lent = address.sub.length();
			if (lent == 0)
				address.hasChild = 0;
			else
				address.hasChild = 1;
		} else {
			address.hasChild = 0;
		}

		return address;
	}
}