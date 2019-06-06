# Application Mobile Alexendre OBLI



L'application mise en oeuvre a pour but de classer les films selon le classement de THE Movie DB

Ce projet m'a permis de découvrir la programmation mobile sur android ainsi que l'architecture qui l'accompagne. 
Lors de ce projet, j'ai pris la décision de faire l'application de façon native pour Android et IOS et de rendre la version qui me semblait être la meilleur des deux. 
Ainsi j'ai pu voir l'ensembles des differences et caractéristque de la programmation native entre les deux plateformes majeurs. 


Et ainsi de confrontter : 
``` java
package com.example.applicationforesiea;

import android.annotation.SuppressLint;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.*;

public class MainActivity extends AppCompatActivity {
    ListView listView = (ListView) findViewById(R.id.mobile_list);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.activity_main);
    }
} 
```
avec 
```swift
import UIKit



class DetailViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
```


### Fonctionalités

- Cache (CORE DATA)
```swift
import CoreData
```
- Deux pages
- MVC
- Git Flow
- Appel API
```html "https://api.themoviedb.org/4/list/1?page=1&api_key=e2afa493459356483ae71ef32311be3b&language=fr-FR"```
- Ecrans de chargement
- Readme
- Push Notifications

## Captures d'écran : 
![](https://github.com/lexers16/ProgramESIEA/blob/master/IMG_8684.PNG)
![](https://github.com/lexers16/ProgramESIEA/blob/master/IMG_8685.PNG)
![](https://github.com/lexers16/ProgramESIEA/blob/master/IMG_8686.PNG)
![](https://github.com/lexers16/ProgramESIEA/blob/master/IMG_8687.PNG)






