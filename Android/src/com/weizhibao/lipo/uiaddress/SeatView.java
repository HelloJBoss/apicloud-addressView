package com.weizhibao.lipo.uiaddress;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.util.AttributeSet;
import android.view.View;

/**
 * 自定义的小对号
 * @author lipo(879736112)
 * gan shi jian, mei you zuo zhu jie
 */
public class SeatView extends View {
	private Paint paint;
	private int width;
	private int height;
	private Path path;

	public SeatView(Context context) {
		super(context);
		initView(context);
	}

	public SeatView(Context context, AttributeSet attrs) {
		super(context, attrs);
		initView(context);
	}

	public SeatView(Context context, AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
		initView(context);
	}

	private void initView(Context context) {
		this.paint = new Paint();
		this.paint.setColor(-1019570);
		this.path = new Path();
		this.paint.setStrokeWidth(3.0F);
		this.paint.setStyle(Paint.Style.STROKE);
	}

	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);
		this.width = getWidth();
		this.height = getHeight();

		this.path.moveTo(1.0F, this.height / 2);
		this.path.lineTo(this.width / 3, this.height - 1);
		this.path.lineTo(this.width - 1, 1.0F);

		canvas.drawPath(this.path, this.paint);
	}

	public void setPaintColor(int paintColor) {
		this.paint.setColor(paintColor);
		invalidate();
	}
}