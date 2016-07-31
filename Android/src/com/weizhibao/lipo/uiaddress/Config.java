package com.weizhibao.lipo.uiaddress;

import android.content.Context;
import com.uzmap.pkg.uzcore.uzmodule.UZModule;
import com.uzmap.pkg.uzcore.uzmodule.UZModuleContext;
import com.uzmap.pkg.uzkit.UZUtility;

/**
 * apicloud的参数
 * @author lipo(879736112)
 * gan shi jian, mei you zuo zhu jie
 */
public class Config {
	public String file_addr;
	public int selected_color;
	public int pro_id;
	public int city_id;
	public int dir_id;

	public Config(UZModule module, UZModuleContext moduleContext,
			Context context) {
		this.file_addr = module.makeRealPath(moduleContext
				.optString("file_addr"));

		this.selected_color = UZUtility.parseCssColor(moduleContext
				.optString("selected_color"));

		this.pro_id = moduleContext.optInt("pro_id", 0);

		this.city_id = moduleContext.optInt("city_id", 0);

		this.dir_id = moduleContext.optInt("dir_id", 0);
	}
}