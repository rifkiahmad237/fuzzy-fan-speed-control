#include <AFMotor.h>
#include <Fuzzy.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <DHT.h>
#define DHTPIN 10
#define DHTTYPE DHT11 
DHT dht(DHTPIN, DHTTYPE);
LiquidCrystal_I2C lcd(0x27, 20, 4);
AF_DCMotor motor1(1);

Fuzzy *fuzzy = new Fuzzy();
// fuzzy input variabel
/** variabel suhu udara **/
FuzzySet *temp_rendah = new FuzzySet(0, 0, 22, 27);
FuzzySet *temp_sedang = new FuzzySet(22, 27, 27, 32);
FuzzySet *temp_tinggi = new FuzzySet(27, 32, 70, 70);

/** variabel kelembaban udara **/
FuzzySet *hum_rendah = new FuzzySet(0, 0, 34, 50);
FuzzySet *hum_sedang = new FuzzySet(34, 50, 50, 66);
FuzzySet *hum_tinggi = new FuzzySet(50, 66, 145, 145);

// fuzzy output
/** output pwm**/
FuzzySet *lambat   = new FuzzySet(0, 0, 55, 110);
FuzzySet *sedang = new FuzzySet(55, 110, 165, 220);
FuzzySet *cepat  = new FuzzySet(165, 220, 255, 255);

float out_pwm;
void setup() {
  // put your setup code here, to run once:
  lcd.init();
  lcd.backlight();
  lcd.clear();
  dht.begin();
  fuzzy_set();
  fuzzy_rule();
}

void loop() {
  //put your main code here, to run repeatedly:
  float temp = dht.readTemperature();
  float hum = dht.readHumidity();

  fuzzy->setInput(1, temp);
  fuzzy->setInput(2, hum);
  fuzzy->fuzzify();

  out_pwm = fuzzy->defuzzify(1);

  motor1.setSpeed(out_pwm);
  motor1.run(FORWARD);
  lcd.setCursor(0,0);
  lcd.print("Suhu: ");
  lcd.setCursor(5,0);
  lcd.print(temp);
  lcd.setCursor(11,0);
  lcd.print("C");
  lcd.setCursor(0,1);
  lcd.print("Kelembaban: ");
  lcd.setCursor(11,1);
  lcd.print(hum);
  lcd.setCursor(17,1);
  lcd.print("RH");
  lcd.setCursor(0,2);
  lcd.print("PWM: ");
  lcd.setCursor(4,2);
  lcd.print(out_pwm);
  condition_state();
  delay(100);
}

void fuzzy_set(){
// fuzzy set
/** variabel input suhu **/    
  FuzzyInput *fuzz_temp = new FuzzyInput(1);

  fuzz_temp->addFuzzySet(temp_rendah);
  fuzz_temp->addFuzzySet(temp_sedang);
  fuzz_temp->addFuzzySet(temp_tinggi);
  fuzzy->addFuzzyInput(fuzz_temp);

/** variabel input kelembaban udara **/
  FuzzyInput *fuzz_hum = new FuzzyInput(2);

  fuzz_hum->addFuzzySet(hum_rendah);
  fuzz_hum->addFuzzySet(hum_sedang);
  fuzz_hum->addFuzzySet(hum_tinggi);
  fuzzy->addFuzzyInput(fuzz_hum);

/** variabel output PWM **/
  FuzzyOutput *fuzz_pwm = new FuzzyOutput(1);

  fuzz_pwm->addFuzzySet(lambat);
  fuzz_pwm->addFuzzySet(sedang);
  fuzz_pwm->addFuzzySet(cepat);
  fuzzy->addFuzzyOutput(fuzz_pwm);
}

void fuzzy_rule(){
  // suhu rendah && kelembaban rendah
  FuzzyRuleAntecedent *rule1 = new FuzzyRuleAntecedent();
  rule1->joinWithAND(temp_rendah, hum_rendah);

  FuzzyRuleConsequent *output1 = new FuzzyRuleConsequent();
  output1->addOutput(sedang);

  FuzzyRule *fuzzyRule1 = new FuzzyRule(1, rule1, output1);
  fuzzy->addFuzzyRule(fuzzyRule1);

  // suhu rendah kelembaban sedang
  FuzzyRuleAntecedent *rule2 = new FuzzyRuleAntecedent();
  rule2->joinWithAND(temp_rendah, hum_sedang);

  FuzzyRuleConsequent *output2 = new FuzzyRuleConsequent();
  output2->addOutput(lambat);

  FuzzyRule *fuzzyRule2 = new FuzzyRule(2, rule2, output2);
  fuzzy->addFuzzyRule(fuzzyRule2);

  // suhu rendah kelembaban tinggi
  FuzzyRuleAntecedent *rule3 = new FuzzyRuleAntecedent();
  rule3->joinWithAND(temp_rendah, hum_tinggi);

  FuzzyRuleConsequent *output3 = new FuzzyRuleConsequent();
  output3->addOutput(lambat);

  FuzzyRule *fuzzyRule3 = new FuzzyRule(3, rule3, output3);
  fuzzy->addFuzzyRule(fuzzyRule3);

  // suhu sedang kelembaban rendah
  FuzzyRuleAntecedent *rule4 = new FuzzyRuleAntecedent();
  rule4->joinWithAND(temp_sedang, hum_rendah);

  FuzzyRuleConsequent *output4 = new FuzzyRuleConsequent();
  output4->addOutput(sedang);

  FuzzyRule *fuzzyRule4 = new FuzzyRule(4, rule4, output4);
  fuzzy->addFuzzyRule(fuzzyRule4);

  // suhu sedang kelembaban sedang
  FuzzyRuleAntecedent *rule5 = new FuzzyRuleAntecedent();
  rule5->joinWithAND(temp_sedang, hum_sedang);

  FuzzyRuleConsequent *output5 = new FuzzyRuleConsequent();
  output5->addOutput(sedang);

  FuzzyRule *fuzzyRule5 = new FuzzyRule(5, rule5, output5);
  fuzzy->addFuzzyRule(fuzzyRule5);

  // suhu sedang kelembaban tinggi
  FuzzyRuleAntecedent *rule6 = new FuzzyRuleAntecedent();
  rule6->joinWithAND(temp_sedang, hum_tinggi);

  FuzzyRuleConsequent *output6 = new FuzzyRuleConsequent();
  output6->addOutput(sedang);

  FuzzyRule *fuzzyRule6 = new FuzzyRule(6, rule6, output6);
  fuzzy->addFuzzyRule(fuzzyRule6);
  
  // suhu tinggi kelembaban rendah
  FuzzyRuleAntecedent *rule7 = new FuzzyRuleAntecedent();
  rule7->joinWithAND(temp_tinggi, hum_rendah);

  FuzzyRuleConsequent *output7 = new FuzzyRuleConsequent();
  output7->addOutput(cepat);

  FuzzyRule *fuzzyRule7 = new FuzzyRule(7, rule7, output7);
  fuzzy->addFuzzyRule(fuzzyRule7);

  // suhu tinggi kelembaban sedang
  FuzzyRuleAntecedent *rule8 = new FuzzyRuleAntecedent();
  rule8->joinWithAND(temp_tinggi, hum_sedang);

  FuzzyRuleConsequent *output8 = new FuzzyRuleConsequent();
  output8->addOutput(cepat);

  FuzzyRule *fuzzyRule8 = new FuzzyRule(8, rule8, output8);
  fuzzy->addFuzzyRule(fuzzyRule8);

  // suhu tinggi kelembaban tinggi
  FuzzyRuleAntecedent *rule9 = new FuzzyRuleAntecedent();
  rule9->joinWithAND(temp_tinggi, hum_tinggi);

  FuzzyRuleConsequent *output9 = new FuzzyRuleConsequent();
  output9->addOutput(cepat);

  FuzzyRule *fuzzyRule9 = new FuzzyRule(9, rule9, output9);
  fuzzy->addFuzzyRule(fuzzyRule9);
}

void condition_state(){
  lcd.setCursor(0,3);
  lcd.print("Motor: ");
  lcd.setCursor(6,3);
  if (out_pwm > 0 && out_pwm <= 110){
    lcd.print("Lambat"); 
  }
  else if (out_pwm > 110 && out_pwm <= 220){
    lcd.print("Sedang");
  }  
  else if (out_pwm > 220 && out_pwm <= 255){
    lcd.print("Cepat  ");
  }
}
