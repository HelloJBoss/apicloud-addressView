package com.weizhibao.lipo.uiaddress;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import com.uzmap.pkg.uzcore.UZResourcesIDFinder;
import java.util.List;

/**
 * 适配器
 * 
 * @author lipo(879736112) gan shi jian, mei you zuo zhu jie
 */
public class AddressAreaAdapter extends BaseAdapter {
	private Activity context;
	private List<AddressInfo> list;
	private LayoutInflater inflater;

	public AddressAreaAdapter(Activity context, List<AddressInfo> list) {
		this.context = context;
		this.list = list;
		this.inflater = context.getLayoutInflater();
	}

	public int getCount() {
		return this.list.size();
	}

	public Object getItem(int position) {
		return this.list.get(position);
	}

	public long getItemId(int position) {
		return position;
	}

	@SuppressWarnings("deprecation")
	@SuppressLint({ "InflateParams" })
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder = null;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = this.inflater.inflate(
					UZResourcesIDFinder.getResLayoutID("item_addr_area"), null);
			holder.item_addr_area_name = ((TextView) convertView
					.findViewById(UZResourcesIDFinder
							.getResIdID("item_addr_area_name")));
			holder.item_addr_area_icon = ((SeatView) convertView
					.findViewById(UZResourcesIDFinder
							.getResIdID("item_addr_area_icon")));
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		AddressInfo str = (AddressInfo) this.list.get(position);
		holder.item_addr_area_name.setText(str.name);
		if (UIAddressView.ids == str.id) {
			if (UIAddressView.config.selected_color != 0)
				holder.item_addr_area_name
						.setTextColor(UIAddressView.config.selected_color);
			else {
				holder.item_addr_area_name.setTextColor(this.context
						.getResources().getColor(
								UZResourcesIDFinder.getResColorID("main_red")));
			}
			holder.item_addr_area_icon
					.setPaintColor(UIAddressView.config.selected_color);
			holder.item_addr_area_icon.setVisibility(0);
		} else {
			holder.item_addr_area_name.setTextColor(this.context.getResources()
					.getColor(UZResourcesIDFinder.getResColorID("main_text")));
			holder.item_addr_area_icon.setVisibility(8);
		}

		return convertView;
	}

	private class ViewHolder {
		TextView item_addr_area_name;
		SeatView item_addr_area_icon;

		private ViewHolder() {
		}
	}
}