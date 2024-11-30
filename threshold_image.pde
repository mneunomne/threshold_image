import controlP5.*;

// image list
String [] paths = {
	"033bb11d-3845-4de8-829a-75f97bfefdf6.png",
	"1d968f4e-ada7-4cb9-a802-285d48900812.png",
	"2f75ba25-d2fb-41da-8c11-291c76d73a8c.png",
	"31c4a361-e58f-46bf-9561-3d9d0fc7eac4.png",
	"568a94b8-6f52-4cee-b611-1b70d24068f3.png",
	"5ee3fcfb-ef39-4d17-bbb1-9f9002ae6295.png",
	"6aecb229-6bc1-458f-a145-8af3a7ad606f----2.png",
	"6aecb229-6bc1-458f-a145-8af3a7ad606f.png",
	"871bd910-8056-4217-b6db-a16122746d3e.png",
	"e6b58b03-322d-434f-9932-65b950bebf5a.png",
	"e9ed6f33-500e-41c9-b20a-07d1750aa311.png",
	"ecf619af-7a87-4d82-a99b-063e0e83ff55.png",
	"ecf9e441-a3a5-4de4-bc4e-5ad7ebff44c2.png"
};

PImage images [] = new PImage[paths.length];

PImage curImage;
PImage thresholded;

int curIndex = 0;

// controlP5
ControlP5 cp5;

int threshold = 128;

String curPath = paths[curIndex];

void setup() {
	// put your setup code here
	size(800, 800);

	cp5 = new ControlP5(this);
	addGUI();

	for (int i = 0; i < paths.length; i++) {
		images[i] = loadImage("data/" + paths[i]);
	}
	curImage = images[curIndex];
	processImage();
}

void addGUI () {
	// threshold slider
	cp5.addSlider("threshold_slider")
		.setPosition(10, 10)
		.setRange(0, 255)
		.setValue(128)
		.setLabel("Threshold")
		;
}

void processImage () {
	curPath = paths[curIndex];
	curImage = images[curIndex];
	PImage img = curImage;
	image(img, 0, 0);
	thresholded = createImage(img.width, img.height, RGB);
	thresholded.loadPixels();
	img.loadPixels();
	for (int i = 0; i < img.pixels.length; i++) {
		if (brightness(img.pixels[i]) > threshold) {
			thresholded.pixels[i] = color(255);
		} else {
			thresholded.pixels[i] = color(0);
		}
	}
	thresholded.updatePixels();
}

void draw() {
	background(0);
  // put your drawing code here
	// fit both images in the window, keeping the aspect ratio
	float imgRatio = (float) curImage.width / curImage.height;
	float winRatio = (float) (width/2) / height;
	float imgH =0;
	float imgW =0;
	float imgY =0;
	float imgX =0;
	if (imgRatio < winRatio) {
		imgH = height;
		imgW = imgH * imgRatio;
	} else {
		imgW = width/2;
		imgH = imgW / imgRatio;
	}
	imgX = (width/2 - imgW) / 2;
	imgY = (height - imgH) / 2;
	image(curImage,imgX, imgY, imgW, imgH);
	image(thresholded, width/2 + imgX, imgY, imgW, imgH);
}

void keyPressed() {
	// put your keypress code here
	// arrow
	if (keyCode == RIGHT || key == 'd') {
		curIndex++;
		if (curIndex >= images.length) {
			curIndex = 0;
		}
		processImage();
	}
	if (keyCode == LEFT || key == 'a') {
		curIndex--;
		if (curIndex < 0) {
			curIndex = images.length - 1;
		}
		processImage();
	}

	if (key == 's') {
		//"data/export/" + curPath + "_threshold_" + threshold + ".png"
		exportThresholded();
	}
}

void exportThresholded() {
	// export as png
	thresholded.save("data/export/" + curPath.replace(".png", "") + "_threshold_" + threshold + ".png");
}


void threshold_slider(int theValue) {
	threshold = theValue;
	processImage();
}