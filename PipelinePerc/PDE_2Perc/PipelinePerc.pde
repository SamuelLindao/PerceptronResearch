PImage img;
PImage imgP;
PImage imgN;
ArrayList<String> imgs = new ArrayList<String>();
int maxImages = 6;
int currentIndex = 0;
int maxRooms = 2;
String imagesPath = "/Imagens";
String sampleImage = "img.png";
float rI = 58;
float gI = 80;
float bI = 115;


class RGB {
  int r;
  int g;
  int b;
  int c;

  RGB(int r, int g, int b, int c) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.c = c;
  }
}

ArrayList<RGB> colors = new ArrayList<RGB>();



void loadImages(String folderPath) {
  File folder = new File(dataPath(folderPath));
  File[] files = folder.listFiles();

  for (File file : files) {
    if (file.isFile() && (file.getName().endsWith(".png") || file.getName().endsWith(".jpg") || file.getName().endsWith(".jpeg"))) {
      imgs.add(folderPath + "/" + file.getName());
      println(folderPath + "/" + file.getName());
    }
  }
}

void setup() {
  int value = 0;

  while (value < maxRooms)
  {
   // print(sketchPath() + imagesPath);
    imgs.clear();
    loadImages( sketchPath() + imagesPath);
    if(value > 0) sampleImage = imgs.get(0);
    
    //Samples

    img = loadImage(sampleImage );
    println(sampleImage + "AAAAAAAA");
    color c;
    float r =0, g= 0, b= 0;
    float n = 0;
    int contp = 0;
    int contn = 0;
    float dv =0;
    int cont = 0;
    //58 80 115
    for (int i=0; i<img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        c = img.get(i, j);
        r = red(c);
        g = green(c);
        b = blue(c);
        n = random(1f);

        dv = dist(r, g, b, rI, gI, bI);

        if (n >= 0.5f && cont < 4096 && r != 255 && g != 255 && b != 255 )
        {
          if (dv < 128)
          {
            contn++;
            colors.add(new RGB((int)r, (int)g, (int)b, -1));
          }
          if (dv >=128)
          {
            contp++;
            colors.add(new RGB((int)r, (int)g, (int)b, +1));
          }
          cont++;
        }
      }//end-for-j
    }//end-for-i
    println("contn : " +contn);
    println("contp : " +contp);

    //Training
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    float bias = 0.0f;
    float w1 = 127.0f;
    float w2 = 127.0f;
    float w3 = 127.0f;
    float s = 0.0f;
    int classV = 0;
    int epocas = 100;
    int count = 0;
    color co;

    float TA = 0.001f;
    float erro = 0;
    float entrada = 0;
    float saida = 0;
    float desejado = 0;

    while (count < epocas) {
      for (int i = 0; i < colors.size(); i++) {

        x = colors.get(i).r;
        y = colors.get(i).g;
        z = colors.get(i).b;
        classV = colors.get(i).c;
        TA = 0.0001f;
        desejado = classV;
        erro = desejado - saida;
        s = (w1 * x) + (w2 * y) + (w3 * z) + bias;

        if (s > 0 && classV < 0 && i < n) {
          w1 = w1 + TA * erro * x;
          w2 = w2 + TA * erro * y;
          w3 = w3 + TA * erro * z;
          saida = s;
        }
      }

      if (w1 < 0) {
        w1 *= -1;
      }

      if (w2 < 0) {
        w2 *= -1;
      }

      count++;
    }

    println("w1: " + w1 + " w2: " + w2 + " w3: " + w3);
    println("Done.");
    
    int counntp = 0;
    int counntn = 0;
    while (currentIndex < maxImages)
    {
      //Classification
      String h= imgs.get(currentIndex);
      img = loadImage(h);
      imgP = loadImage(h);
      imgN =loadImage(h);
      for (int i=0; i<img.width; i++) {
        for (int j = 0; j < img.height; j++) {

          co = img.get(i, j);
          r = red(co);
          g = green(co);
          b = blue(co);

          float newS = (w1*r) + (w2*g) + (w3 * b);
          if (newS > 0 && (r > 25 && g > 25 && b > 25))
          {
            //  print("Vermelho");

            imgP.set(i, j, color(255, 255, 255));
          } else
          {
           // print("Azul");

            imgN.set(i, j, color(255, 255, 255));
          }
        }
      }
      //println(counnt);
      String fileNameA = sketchPath() + "/Resultados/finalImageN"+value + currentIndex+ ".png";
      imgN.save(fileNameA );
      currentIndex++;
    }
    imagesPath = "/Resultados";
    rI = 5;
    gI = 5;
    bI = 5;
    value++;
    count = 0;
    cont=0;
    colors = new ArrayList<RGB>();
    currentIndex=0;
  }
  exit();
}
