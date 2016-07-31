package com.weizhibao.lipo.uiaddress;

import android.animation.Animator;
import android.animation.ObjectAnimator;
import android.content.res.AssetManager;
import android.graphics.drawable.ColorDrawable;
import android.text.TextPaint;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.widget.AdapterView;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.uzmap.pkg.uzcore.UZResourcesIDFinder;
import com.uzmap.pkg.uzcore.UZWebView;
import com.uzmap.pkg.uzcore.uzmodule.UZModule;
import com.uzmap.pkg.uzcore.uzmodule.UZModuleContext;
import com.uzmap.pkg.uzkit.UZUtility;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * apicloud 的 进入口
 * @author lipo(879736112)
 * gan shi jian, mei you zuo zhu jie
 */
public class UIAddressView extends UZModule {
	private int temp = 1;
	private int lineX = 0;
	private int detaX = 0;

	public static int ids = 0;

	private AddressInfo adrInfo1 = new AddressInfo(0, "请选择");
	private AddressInfo adrInfo2 = new AddressInfo(0, "请选择");
	private AddressInfo adrInfo3 = new AddressInfo(0, "请选择");

	private int[] positions = new int[3];
	private ViewGroup decorView;
	private FrameLayout contentView;
	AssetManager asset;
	private JSONArray json;
	public static Config config;
	private UZModuleContext moduleContext;
	private PopupWindow popup;
	private View mainView;
	private LayoutInflater inflater;
	private DisplayMetrics metrics;
	private ImageView imageMark;
	private TextPaint paint;
	private TextView cell_address_pro;
	private TextView cell_address_city;
	private TextView cell_address_area;
	private TextView cell_address_dir;
	private View cell_address_line;
	public ListView cell_address_list;
	private ImageView cell_address_cancel;
	private AddressAreaAdapter areaAdapter;
	private List<TextView> areaTexts;
	private List<AddressInfo> proList;
	private List<AddressInfo> cityList;
	private List<AddressInfo> areaList;
	private View.OnClickListener onclick = new View.OnClickListener() {
		public void onClick(View v) {
			if (v.getId() == UZResourcesIDFinder.getResIdID("cell_address_pro")) {
				if (UIAddressView.this.temp != 1) {
					UIAddressView.this.temp = 1;
					UIAddressView.ids = UIAddressView.this.adrInfo1.id;
					UIAddressView.this.lineSlide(
							UIAddressView.this.cell_address_pro,
							UIAddressView.this.adrInfo1.name);
					UIAddressView.this.initAdapter(UIAddressView.this.proList);
				}

			} else if (v.getId() == UZResourcesIDFinder
					.getResIdID("cell_address_city")) {
				if (UIAddressView.this.temp != 2) {
					UIAddressView.this.temp = 2;
					if (UIAddressView.this.adrInfo2 != null) {
						UIAddressView.ids = UIAddressView.this.adrInfo2.id;
						UIAddressView.this.lineSlide(
								UIAddressView.this.cell_address_city,
								UIAddressView.this.adrInfo2.name);
					} else {
						UIAddressView.this.lineSlide(
								UIAddressView.this.cell_address_city, "请选择");
					}
					UIAddressView.this.initAdapter(UIAddressView.this.cityList);
				}

			} else if (v.getId() == UZResourcesIDFinder
					.getResIdID("cell_address_area")) {
				if (UIAddressView.this.temp != 3) {
					UIAddressView.this.temp = 3;
					if (UIAddressView.this.adrInfo3 != null) {
						UIAddressView.ids = UIAddressView.this.adrInfo3.id;
						UIAddressView.this.lineSlide(
								UIAddressView.this.cell_address_area,
								UIAddressView.this.adrInfo3.name);
					} else {
						UIAddressView.this.lineSlide(
								UIAddressView.this.cell_address_area, "请选择");
					}

					UIAddressView.this.initAdapter(UIAddressView.this.areaList);
				}
			} else if (v.getId() == UZResourcesIDFinder
					.getResIdID("cell_address_cancel"))
				UIAddressView.this.dismiss();
		}
	};

	public UIAddressView(UZWebView webView) {
		super(webView);
	}

	public void jsmethod_open(UZModuleContext moduleContext) {
		
		this.asset = this.mContext.getAssets();
		config = new Config(this, moduleContext, this.mContext);
		initAddress();
		JSONObject result = new JSONObject();
		try {
			result.put("status", true);
			result.put("msg", "联动地址初始化成功");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		moduleContext.success(result, false);
	}

	public void jsmethod_show(UZModuleContext moduleContext) {
		this.moduleContext = moduleContext;
		showPopup();
	}

	private void initAddress() {
		this.decorView = ((ViewGroup) this.mContext.getWindow().getDecorView());
		this.contentView = ((FrameLayout) this.decorView.getChildAt(0)
				.findViewById(16908290));

		this.inflater = this.mContext.getLayoutInflater();

		this.mainView = this.inflater.inflate(
				UZResourcesIDFinder.getResLayoutID("cell_address_area"), null);

		this.metrics = this.mContext.getResources().getDisplayMetrics();

		this.areaTexts = new ArrayList<TextView>();
		this.proList = new ArrayList<AddressInfo>();
		this.cityList = new ArrayList<AddressInfo>();
		this.areaList = new ArrayList<AddressInfo>();

		this.detaX = UZUtility.dipToPix(12);

		initPopup();
		initView();
		getJsonData();
		initData();
	}

	public void initPopup() {
		this.popup = new PopupWindow(this.mainView, -1,
				this.metrics.heightPixels * 3 / 5, true);
		ColorDrawable drawable = new ColorDrawable(
				UZResourcesIDFinder.getResColorID("black_tranl"));
		this.popup.setBackgroundDrawable(drawable);

		this.popup.setInputMethodMode(1);
		this.popup.setSoftInputMode(16);
		this.popup.setOutsideTouchable(true);

		this.popup.setAnimationStyle(UZResourcesIDFinder
				.getResStyleID("popup_animation"));

		this.popup.setOnDismissListener(new PopupWindow.OnDismissListener() {
			public void onDismiss() {
				if (UIAddressView.this.contentView != null)
					UIAddressView.this.contentView
							.removeView(UIAddressView.this.imageMark);
			}
		});
	}

	private void initView() {
		this.imageMark = new ImageView(this.mContext);
		FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(-1, -1);
		this.imageMark.setLayoutParams(params);
		this.imageMark.setImageResource(UZResourcesIDFinder
				.getResColorID("black_tranl"));

		this.cell_address_pro = ((TextView) this.mainView
				.findViewById(UZResourcesIDFinder
						.getResIdID("cell_address_pro")));
		this.cell_address_city = ((TextView) this.mainView
				.findViewById(UZResourcesIDFinder
						.getResIdID("cell_address_city")));
		this.cell_address_area = ((TextView) this.mainView
				.findViewById(UZResourcesIDFinder
						.getResIdID("cell_address_area")));
		this.cell_address_dir = ((TextView) this.mainView
				.findViewById(UZResourcesIDFinder
						.getResIdID("cell_address_dir")));
		this.cell_address_line = this.mainView.findViewById(UZResourcesIDFinder
				.getResIdID("cell_address_line"));
		this.cell_address_list = ((ListView) this.mainView
				.findViewById(UZResourcesIDFinder
						.getResIdID("cell_address_area_list")));
		this.cell_address_cancel = ((ImageView) this.mainView
				.findViewById(UZResourcesIDFinder
						.getResIdID("cell_address_cancel")));

		this.areaTexts.add(this.cell_address_pro);
		this.areaTexts.add(this.cell_address_city);
		this.areaTexts.add(this.cell_address_area);

		this.cell_address_pro.setOnClickListener(this.onclick);
		this.cell_address_city.setOnClickListener(this.onclick);
		this.cell_address_area.setOnClickListener(this.onclick);
		this.cell_address_dir.setOnClickListener(this.onclick);
		this.cell_address_cancel.setOnClickListener(this.onclick);

		if (config.selected_color != 0) {
			this.cell_address_line.setBackgroundColor(config.selected_color);
		}

		this.paint = this.cell_address_pro.getPaint();

		if (config.pro_id == 0) {
			lineSlide(this.cell_address_pro, "请选择");
		}

		this.areaAdapter = new AddressAreaAdapter(this.mContext, this.proList);
		this.cell_address_list.setAdapter(this.areaAdapter);

		this.cell_address_list
				.setOnItemClickListener(new AdapterView.OnItemClickListener() {
					public void onItemClick(AdapterView<?> parent, View view,
							int position, long id) {
						if (UIAddressView.this.temp == 1) {
							UIAddressView.this.temp = 2;
							UIAddressView.this.cityList.clear();
							UIAddressView.this.areaList.clear();
							UIAddressView.this.adrInfo2 = null;
							UIAddressView.this.adrInfo3 = null;

							UIAddressView.this.adrInfo1 = ((AddressInfo) UIAddressView.this.proList
									.get(position));
							UIAddressView.this.positions[0] = position;
							UIAddressView.this.cell_address_pro
									.setText(UIAddressView.this.adrInfo1.name);
							if (UIAddressView.this.adrInfo1.hasChild == 1) {
								int lent = UIAddressView.this.adrInfo1.sub
										.length();
								for (int i = 0; i < lent; i++) {
									JSONObject jsonObj = UIAddressView.this.adrInfo1.sub
											.optJSONObject(i);
									UIAddressView.this.cityList.add(AddressInfo
											.fromJson(jsonObj));
								}
								UIAddressView.this.areaAdapter = new AddressAreaAdapter(
										UIAddressView.this.mContext,
										UIAddressView.this.cityList);
								UIAddressView.this.cell_address_list
										.setAdapter(UIAddressView.this.areaAdapter);
								UIAddressView.this.cell_address_city
										.setVisibility(0);
								UIAddressView.this.cell_address_area
										.setVisibility(8);
								UIAddressView.this.cell_address_city
										.setText("请选择");
								UIAddressView.this.cell_address_city
										.post(new Runnable() {
											public void run() {
												UIAddressView.this
														.lineSlide(
																UIAddressView.this.cell_address_city,
																"请选择");
											}
										});
							}
						} else if (UIAddressView.this.temp == 2) {
							UIAddressView.this.temp = 3;
							UIAddressView.this.adrInfo2 = ((AddressInfo) UIAddressView.this.cityList
									.get(position));
							UIAddressView.this.positions[1] = position;
							UIAddressView.this.areaList.clear();
							UIAddressView.this.adrInfo3 = null;
							UIAddressView.this.cell_address_city
									.setText(UIAddressView.this.adrInfo2.name);
							if (UIAddressView.this.adrInfo2.hasChild == 1) {
								int lent = UIAddressView.this.adrInfo2.sub
										.length();
								for (int i = 0; i < lent; i++) {
									JSONObject jsonObj = UIAddressView.this.adrInfo2.sub
											.optJSONObject(i);
									UIAddressView.this.areaList.add(AddressInfo
											.fromJson(jsonObj));
								}
								UIAddressView.this.areaAdapter = new AddressAreaAdapter(
										UIAddressView.this.mContext,
										UIAddressView.this.areaList);
								UIAddressView.this.cell_address_list
										.setAdapter(UIAddressView.this.areaAdapter);
								UIAddressView.this.cell_address_area
										.setVisibility(0);
								UIAddressView.this.cell_address_area
										.setText("请选择");
								UIAddressView.this.cell_address_area
										.post(new Runnable() {
											public void run() {
												UIAddressView.this
														.lineSlide(
																UIAddressView.this.cell_address_area,
																"请选择");
											}
										});
							}
						} else if (UIAddressView.this.temp == 3) {
							UIAddressView.this.adrInfo3 = ((AddressInfo) UIAddressView.this.areaList
									.get(position));
							UIAddressView.this.positions[2] = position;
							UIAddressView.this.cell_address_area
									.setText(UIAddressView.this.adrInfo3.name);
							UIAddressView.this
									.lineWidth(UIAddressView.this.adrInfo3.name);
							UIAddressView.ids = UIAddressView.this.adrInfo3.id;
							UIAddressView.this.callBack();
							UIAddressView.this.dismiss();
						}
					}
				});
	}

	private void initData() {
		if (config.pro_id != 0) {
			int lent1 = this.proList.size();
			for (int i = 0; i < lent1; i++) {
				if (config.pro_id == ((AddressInfo) this.proList.get(i)).id) {
					this.adrInfo1 = ((AddressInfo) this.proList.get(i));
					this.positions[0] = i;
					this.cell_address_pro.setText(this.adrInfo1.name);
				}
			}

			if (this.adrInfo1.hasChild == 1) {
				int lent = this.adrInfo1.sub.length();
				for (int i = 0; i < lent; i++) {
					JSONObject jsonObj = this.adrInfo1.sub.optJSONObject(i);
					AddressInfo address = AddressInfo.fromJson(jsonObj);
					this.cityList.add(address);
					if (config.city_id == address.id) {
						this.adrInfo2 = address;
						this.positions[1] = i;
						this.cell_address_city.setText(address.name);
						this.cell_address_city.setVisibility(0);
					}
				}
			}

			if ((config.city_id != 0) && (this.adrInfo2.hasChild == 1)) {
				int lent = this.adrInfo2.sub.length();
				for (int i = 0; i < lent; i++) {
					JSONObject jsonObj = this.adrInfo2.sub.optJSONObject(i);
					AddressInfo address = AddressInfo.fromJson(jsonObj);
					this.areaList.add(address);
					if (config.dir_id == address.id) {
						this.positions[2] = i;
						this.cell_address_area.setVisibility(0);
						this.adrInfo3 = address;
						this.cell_address_area.setText(this.adrInfo3.name);
						this.temp = 3;
						this.cell_address_area.post(new Runnable() {
							public void run() {
								UIAddressView.this
										.initLine(
												UIAddressView.this.adrInfo3.name,
												UIAddressView.this.adrInfo1.name
														+ UIAddressView.this.adrInfo2.name);
							}
						});
						ids = address.id;
						this.areaAdapter = new AddressAreaAdapter(
								this.mContext, this.areaList);
						this.cell_address_list.setAdapter(this.areaAdapter);
					}
				}
			}
		}
	}

	public void showPopup() {
		this.contentView.addView(this.imageMark);
		this.popup.showAtLocation(this.contentView, 80, 0, 0);
	}

	public void dismiss() {
		this.popup.dismiss();
	}

	public boolean isShowing() {
		return this.popup.isShowing();
	}

	private void initAdapter(List<AddressInfo> list) {
		this.areaAdapter = new AddressAreaAdapter(this.mContext, list);
		this.cell_address_list.setAdapter(this.areaAdapter);
		scrollList();
	}

	private void initLine(String addr, String addr2) {
		selectText();

		int width = (int) this.paint.measureText(addr);
		RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) this.cell_address_line
				.getLayoutParams();
		params.width = width;
		this.cell_address_line.setLayoutParams(params);
		this.detaX = 0;
		this.lineX = (UZUtility.dipToPix(62) + (int) this.paint
				.measureText(addr2));
		ObjectAnimator anim = ObjectAnimator.ofFloat(this.cell_address_line,
				"translationX", new float[] { 0.0F, this.lineX }).setDuration(
				20L);
		anim.start();
	}

	private void lineWidth(String addr) {
		int width = (int) this.paint.measureText(addr);
		RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) this.cell_address_line
				.getLayoutParams();
		params.width = width;
		this.cell_address_line.setLayoutParams(params);
	}

	private void lineSlide(View view, String addr) {
		selectText();
		int left = view.getLeft();
		int x = left + UZUtility.dipToPix(10) + this.detaX;

		ObjectAnimator anim = ObjectAnimator.ofFloat(this.cell_address_line,
				"translationX", new float[] { this.lineX, x })
				.setDuration(200L);
		anim.setInterpolator(new AccelerateDecelerateInterpolator());
		anim.start();
		this.detaX = 0;
		this.lineX = x;
		lineWidth(addr);

		anim.addListener(new Animator.AnimatorListener() {
			public void onAnimationStart(Animator animation) {
			}

			public void onAnimationRepeat(Animator animation) {
			}

			public void onAnimationEnd(Animator animation) {
			}

			public void onAnimationCancel(Animator animation) {
			}
		});
	}

	private void getJsonData() {
		StringBuffer sb = new StringBuffer();
		InputStream is = null;
		try {
			if ((config.file_addr != null) && (!"".equals(config.file_addr)))
				is = UZUtility.guessInputStream(config.file_addr);
			else {
				is = this.asset.open("data/district.txt");
			}

			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			String temp = null;
			while ((temp = br.readLine()) != null) {
				sb.append(temp);
			}
			br.close();

			this.json = new JSONArray(sb.toString());
			sb = null;
		} catch (IOException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}

		int lent = this.json.length();
		for (int i = 0; i < lent; i++) {
			JSONObject jsonObj = this.json.optJSONObject(i);
			this.proList.add(AddressInfo.fromJson(jsonObj));
		}
	}

	@SuppressWarnings("deprecation")
	private void selectText() {
		for (int i = 0; i < 3; i++)
			if (i + 1 == this.temp) {
				if (config.selected_color != 0)
					((TextView) this.areaTexts.get(i))
							.setTextColor(config.selected_color);
				else
					((TextView) this.areaTexts.get(i))
							.setTextColor(this.mContext.getResources()
									.getColor(
											UZResourcesIDFinder
													.getResColorID("main_red")));
			} else
				((TextView) this.areaTexts.get(i))
						.setTextColor(this.mContext.getResources().getColor(
								UZResourcesIDFinder.getResColorID("main_text")));
	}

	private void scrollList() {
		int position = this.positions[(this.temp - 1)];
		Log.i("zfb_json", "position:" + position);
		if (position > 4)
			this.cell_address_list.setSelection(position - 4);
	}

	private void callBack() {
		JSONObject rectJson = new JSONObject();
		JSONArray array = new JSONArray();
		if ((this.adrInfo1 != null) && (this.adrInfo1.id != 0)) {
			JSONObject json1 = new JSONObject();
			try {
				json1.put("id", this.adrInfo1.id);
				json1.put("name", this.adrInfo1.name);
				array.put(json1);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}

		if ((this.adrInfo2 != null) && (this.adrInfo2.id != 0)) {
			JSONObject json2 = new JSONObject();
			try {
				json2.put("id", this.adrInfo2.id);
				json2.put("name", this.adrInfo2.name);
				array.put(json2);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}

		if ((this.adrInfo3 != null) && (this.adrInfo3.id != 0)) {
			JSONObject json3 = new JSONObject();
			try {
				json3.put("id", this.adrInfo3.id);
				json3.put("name", this.adrInfo3.name);
				array.put(json3);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		try {
			rectJson.put("status", true);
			rectJson.put("data", array);
			rectJson.put("msg", "回掉成功");
		} catch (JSONException e) {
			e.printStackTrace();
		}

		this.moduleContext.success(rectJson, false);
	}
}