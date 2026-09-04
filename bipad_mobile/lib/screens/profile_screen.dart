import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ==========================================
// ALL 77 DISTRICTS & LOCAL BODIES OF NEPAL
// ==========================================
const Map<String, List<String>> nepalAdministrativeData = {
  // PROVINCE 1: KOSHI (14 Districts)
  'Bhojpur': [
    'Bhojpur Municipality (नगरपालिका)',
    'Shadanand Municipality (नगरपालिका)',
    'Hatuwagadhi Rural Municipality (गाउँपालिका)',
    'Ramprasad Rai Rural Municipality (गाउँपालिका)',
    'Aamchok Rural Municipality (गाउँपालिका)',
    'Tyamke Maiyum Rural Municipality (गाउँपालिका)',
    'Arun Rural Municipality (गाउँपालिका)',
    'Pauwadungma Rural Municipality (गाउँपालिका)',
    'Salpasilichho Rural Municipality (गाउँपालिका)',
  ],
  'Dhankuta': [
    'Dhankuta Municipality (नगरपालिका)',
    'Pakhribas Municipality (नगरपालिका)',
    'Mahalaxmi Municipality (नगरपालिका)',
    'Sangurigadhi Rural Municipality (गाउँपालिका)',
    'Khalsa Chhintang Sahidbhumi Rural Municipality (गाउँपालिका)',
    'Chhathar Jorpati Rural Municipality (गाउँपालिका)',
    'Chaubise Rural Municipality (गाउँपालिका)',
  ],
  'Ilam': [
    'Ilam Municipality (नगरपालिका)',
    'Deumai Municipality (नगरपालिका)',
    'Mai Municipality (नगरपालिका)',
    'Suryodaya Municipality (नगरपालिका)',
    'Fakphokthum Rural Municipality (गाउँपालिका)',
    'Chulachuli Rural Municipality (गाउँपालिका)',
    'Maijogmai Rural Municipality (गाउँपालिका)',
    'Mangsebung Rural Municipality (गाउँपालिका)',
    'Rong Rural Municipality (गाउँपालिका)',
    'Sandakpur Rural Municipality (गाउँपालिका)',
  ],
  'Jhapa': [
    'Bhadrapur Municipality (नगरपालिका)',
    'Damak Municipality (नगरपालिका)',
    'Birtamod Municipality (नगरपालिका)',
    'Mechinagar Municipality (नगरपालिका)',
    'Arjundhara Municipality (नगरपालिका)',
    'Kankai Municipality (नगरपालिका)',
    'Shivasatakshi Municipality (नगरपालिका)',
    'Gauradaha Municipality (नगरपालिका)',
    'Kamal Rural Municipality (गाउँपालिका)',
    'Gauriganj Rural Municipality (गाउँपालिका)',
    'Barhadashi Rural Municipality (गाउँपालिका)',
    'Jhapa Rural Municipality (गाउँपालिका)',
    'Buddhashanti Rural Municipality (गाउँपालिका)',
    'Haldibari Rural Municipality (गाउँपालिका)',
    'Kachankawal Rural Municipality (गाउँपालिका)',
  ],
  'Khotang': [
    'Diktel Rupakot Majhuwagadhi Municipality (नगरपालिका)',
    'Halesi Tuwachung Municipality (नगरपालिका)',
    'Khotehang Rural Municipality (गाउँपालिका)',
    'Diprung Chuichumma Rural Municipality (गाउँपालिका)',
    'Aiselukharka Rural Municipality (गाउँपालिका)',
    'Jantedhunga Rural Municipality (गाउँपालिका)',
    'Kepilasgadhi Rural Municipality (गाउँपालिका)',
    'Barahapokhari Rural Municipality (गाउँपालिका)',
    'Rawabesi Rural Municipality (गाउँपालिका)',
    'Sakela Rural Municipality (गाउँपालिका)',
  ],
  'Morang': [
    'Biratnagar Metropolitan City (महानगरपालिका)',
    'Belbari Municipality (नगरपालिका)',
    'Letang Municipality (नगरपालिका)',
    'Pathari-Sanischare Municipality (नगरपालिका)',
    'Rangeli Municipality (नगरपालिका)',
    'Ratuwamai Municipality (नगरपालिका)',
    'Sunwarshi Municipality (नगरपालिका)',
    'Urlabari Municipality (नगरपालिका)',
    'SundarHaraicha Municipality (नगरपालिका)',
    'Budhiganga Rural Municipality (गाउँपालिका)',
    'Dhanpalthan Rural Municipality (गाउँपालिका)',
    'Gramthan Rural Municipality (गाउँपालिका)',
    'Jahada Rural Municipality (गाउँपालिका)',
    'Kanepokhari Rural Municipality (गाउँपालिका)',
    'Katahari Rural Municipality (गाउँपालिका)',
    'Kerabari Rural Municipality (गाउँपालिका)',
    'Miklajung Rural Municipality (गाउँपालिका)',
  ],
  'Okhaldhunga': [
    'Siddhicharan Municipality (नगरपालिका)',
    'Khijidemba Rural Municipality (गाउँपालिका)',
    'Champadevi Rural Municipality (गाउँपालिका)',
    'Chisankhugadhi Rural Municipality (गाउँपालिका)',
    'Manebhanjyang Rural Municipality (गाउँपालिका)',
    'Molung Rural Municipality (गाउँपालिका)',
    'Likhu Rural Municipality (गाउँपालिका)',
    'Sunkoshi Rural Municipality (गाउँपालिका)',
  ],
  'Panchthar': [
    'Phidim Municipality (नगरपालिका)',
    'Phalelung Rural Municipality (गाउँपालिका)',
    'Phalgunanda Rural Municipality (गाउँपालिका)',
    'Hilihang Rural Municipality (गाउँपालिका)',
    'Kummayak Rural Municipality (गाउँपालिका)',
    'Miklajung Rural Municipality (गाउँपालिका)',
    'Tumvewa Rural Municipality (गाउँपालिका)',
    'Yangwarak Rural Municipality (गाउँपालिका)',
  ],
  'Sankhuwasabha': [
    'Chainpur Municipality (नगरपालिका)',
    'Dharmadevi Municipality (नगरपालिका)',
    'Khandbari Municipality (नगरपालिका)',
    'Madi Municipality (नगरपालिका)',
    'Panchkhapan Municipality (नगरपालिका)',
    'Bhotkhola Rural Municipality (गाउँपालिका)',
    'Chichila Rural Municipality (गाउँपालिका)',
    'Makalu Rural Municipality (गाउँपालिका)',
    'Sabhapokhari Rural Municipality (गाउँपालिका)',
    'Silichong Rural Municipality (गाउँपालिका)',
  ],
  'Solukhumbu': [
    'Solududhkunda Municipality (नगरपालिका)',
    'Dudhkaushika Rural Municipality (गाउँपालिका)',
    'Nechasalyan Rural Municipality (गाउँपालिका)',
    'Dudhkoshi Rural Municipality (गाउँपालिका)',
    'Maha Kulung Rural Municipality (गाउँपालिका)',
    'Sotang Rural Municipality (गाउँपालिका)',
    'Khumbu Pasang Lhamu Rural Municipality (गाउँपालिका)',
    'Likhu Pike Rural Municipality (गाउँपालिका)',
  ],
  'Sunsari': [
    'Dharan Sub-Metropolitan City (उप-महानगरपालिका)',
    'Itahari Sub-Metropolitan City (उप-महानगरपालिका)',
    'Inaruwa Municipality (नगरपालिका)',
    'Duhabi Municipality (नगरपालिका)',
    'Ramdhuni Municipality (नगरपालिका)',
    'Barahachhetra Municipality (नगरपालिका)',
    'Dewanganj Rural Municipality (गाउँपालिका)',
    'Koshi Rural Municipality (गाउँपालिका)',
    'Gadhi Rural Municipality (गाउँपालिका)',
    'Barju Rural Municipality (गाउँपालिका)',
    'Bhokraha Narsing Rural Municipality (गाउँपालिका)',
    'Harinagara Rural Municipality (गाउँपालिका)',
  ],
  'Taplejung': [
    'Phungling Municipality (नगरपालिका)',
    'Aathrai Tribeni Rural Municipality (गाउँपालिका)',
    'Sidingba Rural Municipality (गाउँपालिका)',
    'Faktanglung Rural Municipality (गाउँपालिका)',
    'Mikwakhola Rural Municipality (गाउँपालिका)',
    'Meringden Rural Municipality (गाउँपालिका)',
    'Maiwakhola Rural Municipality (गाउँपालिका)',
    'Pathibhara Yangwarak Rural Municipality (गाउँपालिका)',
    'Sirijangha Rural Municipality (गाउँपालिका)',
  ],
  'Terhathum': [
    'Myanglung Municipality (नगरपालिका)',
    'Laligurans Municipality (नगरपालिका)',
    'Aathrai Rural Municipality (गाउँपालिका)',
    'Chhathar Rural Municipality (गाउँपालिका)',
    'Fedap Rural Municipality (गाउँपालिका)',
    'Menchhayayem Rural Municipality (गाउँपालिका)',
  ],
  'Udayapur': [
    'Triyuga Municipality (नगरपालिका)',
    'Katari Municipality (नगरपालिका)',
    'Chaudandigadhi Municipality (नगरपालिका)',
    'Belaka Municipality (नगरपालिका)',
    'Udayapurgadhi Rural Municipality (गाउँपालिका)',
    'Tapli Rural Municipality (गाउँपालिका)',
    'Rautamai Rural Municipality (गाउँपालिका)',
    'Limchungbung Rural Municipality (गाउँपालिका)',
  ],

  // PROVINCE 2: MADHESH (8 Districts)
  'Bara': [
    'Kalaiya Sub-Metropolitan City (उप-महानगरपालिका)',
    'Jeetpur Simara Sub-Metropolitan City (उप-महानगरपालिका)',
    'Kolhabi Municipality (नगरपालिका)',
    'Nijgadh Municipality (नगरपालिका)',
    'Mahagadhimai Municipality (नगरपालिका)',
    'Simroungadh Municipality (नगरपालिका)',
    'Pacharouta Municipality (नगरपालिका)',
    'Adarshakotwal Rural Municipality (गाउँपालिका)',
    'Karaiyamai Rural Municipality (गाउँपालिका)',
    'Devtal Rural Municipality (गाउँपालिका)',
    'Parwanipur Rural Municipality (गाउँपालिका)',
    'Prasauni Rural Municipality (गाउँपालिका)',
    'Pheta Rural Municipality (गाउँपालिका)',
    'Baragadhi Rural Municipality (गाउँपालिका)',
    'Suwarna Rural Municipality (गाउँपालिका)',
    'Bishrampur Rural Municipality (गाउँपालिका)',
  ],
  'Dhanusha': [
    'Janakpurdham Sub-Metropolitan City (उप-महानगरपालिका)',
    'Chhireshwarnath Municipality (नगरपालिका)',
    'Ganeshman Charnath Municipality (नगरपालिका)',
    'Dhanusadham Municipality (नगरपालिका)',
    'Nagarain Municipality (नगरपालिका)',
    'Bideha Municipality (नगरपालिका)',
    'Mithila Municipality (नगरपालिका)',
    'Shahidnagar Municipality (नगरपालिका)',
    'Sabaila Municipality (नगरपालिका)',
    'Kamala Municipality (नगरपालिका)',
    'Mithila Bihari Municipality (नगरपालिका)',
    'Hansapur Municipality (नगरपालिका)',
    'Janaknandini Rural Municipality (गाउँपालिका)',
    'Bateshwar Rural Municipality (गाउँपालिका)',
    'Mukhiyapatti Musharniya Rural Municipality (गाउँपालिका)',
    'Lakshminiya Rural Municipality (गाउँपालिका)',
    'Aurahi Rural Municipality (गाउँपालिका)',
    'Dhanauji Rural Municipality (गाउँपालिका)',
  ],
  'Mahottari': [
    'Jaleshwar Municipality (नगरपालिका)',
    'Bardibas Municipality (नगरपालिका)',
    'Gaushala Municipality (नगरपालिका)',
    'Loharpatti Municipality (नगरपालिका)',
    'Ramgopalpur Municipality (नगरपालिका)',
    'Manra Siswa Municipality (नगरपालिका)',
    'Matihani Municipality (नगरपालिका)',
    'Bhangaha Municipality (नगरपालिका)',
    'Balwa Municipality (नगरपालिका)',
    'Aurahi Municipality (नगरपालिका)',
    'Ekdara Rural Municipality (गाउँपालिका)',
    'Sonama Rural Municipality (गाउँपालिका)',
    'Samsi Rural Municipality (गाउँपालिका)',
    'Mahottari Rural Municipality (गाउँपालिका)',
    'Pipra Rural Municipality (गाउँपालिका)',
  ],
  'Parsa': [
    'Birgunj Metropolitan City (महानगरपालिका)',
    'Pokhariya Municipality (नगरपालिका)',
    'Parsagadhi Municipality (नगरपालिका)',
    'Bahudarmai Municipality (नगरपालिका)',
    'Bindabasini Rural Municipality (गाउँपालिका)',
    'Dhobini Rural Municipality (गाउँपालिका)',
    'Chhipaharmai Rural Municipality (गाउँपालिका)',
    'Jagarnathpur Rural Municipality (गाउँपालिका)',
    'Jirabhawani Rural Municipality (गाउँपालिका)',
    'Kalikamai Rural Municipality (गाउँपालिका)',
    'Pakaha Mainpur Rural Municipality (गाउँपालिका)',
    'Paterwa Sugauli Rural Municipality (गाउँपालिका)',
    'Sakhuwa Prasani Rural Municipality (गाउँपालिका)',
    'Thori Rural Municipality (गाउँपालिका)',
  ],
  'Rautahat': [
    'Gaur Municipality (नगरपालिका)',
    'Chandrapur Municipality (नगरपालिका)',
    'Garuda Municipality (नगरपालिका)',
    'Gujara Municipality (नगरपालिका)',
    'Dewahi Gonahi Municipality (नगरपालिका)',
    'Brindaban Municipality (नगरपालिका)',
    'Katahariya Municipality (नगरपालिका)',
    'Gadhimai Municipality (नगरपालिका)',
    'Madhav Narayan Municipality (नगरपालिका)',
    'Maulapur Municipality (नगरपालिका)',
    'Baudhimai Municipality (नगरपालिका)',
    'Paroha Municipality (नगरपालिका)',
    'Phatuwa Bijayapur Municipality (नगरपालिका)',
    'Ishnath Municipality (नगरपालिका)',
    'Rajpur Municipality (नगरपालिका)',
    'Rajdevi Municipality (नगरपालिका)',
    'Durga Bhagwati Rural Municipality (गाउँपालिका)',
    'Yamunamai Rural Municipality (गाउँपालिका)',
  ],
  'Saptari': [
    'Rajbiraj Municipality (नगरपालिका)',
    'Kanchanrup Municipality (नगरपालिका)',
    'Dakneshwori Municipality (नगरपालिका)',
    'Bodebarsain Municipality (नगरपालिका)',
    'Khadak Municipality (नगरपालिका)',
    'Surunga Municipality (नगरपालिका)',
    'Hanumannagar Kankalini Municipality (नगरपालिका)',
    'Saptakoshi Municipality (नगरपालिका)',
    'Shambhunath Municipality (नगरपालिका)',
    'Agnisair Krishna Savaran Rural Municipality (गाउँपालिका)',
    'Chhinnamasta Rural Municipality (गाउँपालिका)',
    'Mahadeva Rural Municipality (गाउँपालिका)',
    'Tirhut Rural Municipality (गाउँपालिका)',
    'Tilathi Koiladi Rural Municipality (गाउँपालिका)',
    'Rupani Rural Municipality (गाउँपालिका)',
    'Balan Bihul Rural Municipality (गाउँपालिका)',
    'Bishnupur Rural Municipality (गाउँपालिका)',
    'Rajgadh Rural Municipality (गाउँपालिका)',
  ],
  'Sarlahi': [
    'Malangwa Municipality (नगरपालिका)',
    'Hariwan Municipality (नगरपालिका)',
    'Lalbandi Municipality (नगरपालिका)',
    'Ishworpur Municipality (नगरपालिका)',
    'Barahathwa Municipality (नगरपालिका)',
    'Haripur Municipality (नगरपालिका)',
    'Haripurwa Municipality (नगरपालिका)',
    'Bagmati Municipality (नगरपालिका)',
    'Kabilasi Municipality (नगरपालिका)',
    'Godaita Municipality (नगरपालिका)',
    'Balara Municipality (नगरपालिका)',
    'Chakraghatta Rural Municipality (गाउँपालिका)',
    'Chandranagar Rural Municipality (गाउँपालिका)',
    'Dhankaul Rural Municipality (गाउँपालिका)',
    'Brahmapuri Rural Municipality (गाउँपालिका)',
    'Ramnagar Rural Municipality (गाउँपालिका)',
    'Kaudena Rural Municipality (गाउँपालिका)',
    'Parsa Rural Municipality (गाउँपालिका)',
    'Bishnu Rural Municipality (गाउँपालिका)',
    'Basbariya Rural Municipality (गाउँपालिका)',
  ],
  'Siraha': [
    'Siraha Municipality (नगरपालिका)',
    'Lahan Municipality (नगरपालिका)',
    'Golbazar Municipality (नगरपालिका)',
    'Mirchaiya Municipality (नगरपालिका)',
    'Kalyanpur Municipality (नगरपालिका)',
    'Dhangadhimai Municipality (नगरपालिका)',
    'Sukhipur Municipality (नगरपालिका)',
    'Karjanha Municipality (नगरपालिका)',
    'Bishnupur Rural Municipality (गाउँपालिका)',
    'Bariyarpatti Rural Municipality (गाउँपालिका)',
    'Aurahi Rural Municipality (गाउँपालिका)',
    'Arnama Rural Municipality (गाउँपालिका)',
    'Bhagwanpur Rural Municipality (गाउँपालिका)',
    'Naraha Rural Municipality (गाउँपालिका)',
    'Sakhuwanankarkatti Rural Municipality (गाउँपालिका)',
    'Laxmipur Patari Rural Municipality (गाउँपालिका)',
    'Navarajpur Rural Municipality (गाउँपालिका)',
  ],

  // PROVINCE 3: BAGMATI (13 Districts)
  'Bhaktapur': [
    'Bhaktapur Municipality (नगरपालिका)',
    'Madhyapur Thimi Municipality (नगरपालिका)',
    'Suryabinayak Municipality (नगरपालिका)',
    'Changunarayan Municipality (नगरपालिका)',
  ],
  'Chitwan': [
    'Bharatpur Metropolitan City (महानगरपालिका)',
    'Ratnanagar Municipality (नगरपालिका)',
    'Khairhani Municipality (नगरपालिका)',
    'Madi Municipality (नगरपालिका)',
    'Rapti Municipality (नगरपालिका)',
    'Kalika Municipality (नगरपालिका)',
    'Ichhyakamana Rural Municipality (गाउँपालिका)',
  ],
  'Dhading': [
    'Nilkantha Municipality (नगरपालिका)',
    'Dhunibeshi Municipality (नगरपालिका)',
    'Gajuri Rural Municipality (गाउँपालिका)',
    'Galchhi Rural Municipality (गाउँपालिका)',
    'Thakre Rural Municipality (गाउँपालिका)',
    'Benighat Rorang Rural Municipality (गाउँपालिका)',
    'Jwalamukhi Rural Municipality (गाउँपालिका)',
    'Siddhalek Rural Municipality (गाउँपालिका)',
    'Tripurasundari Rural Municipality (गाउँपालिका)',
    'Gangajamuna Rural Municipality (गाउँपालिका)',
    'Netrawati Dabjong Rural Municipality (गाउँपालिका)',
    'Khaniyabas Rural Municipality (गाउँपालिका)',
    'Rubi Valley Rural Municipality (गाउँपालिका)',
  ],
  'Dolakha': [
    'Bhimeshwar Municipality (नगरपालिका)',
    'Jiri Municipality (नगरपालिका)',
    'Kalinchok Rural Municipality (गाउँपालिका)',
    'Gaurishankar Rural Municipality (गाउँपालिका)',
    'Baiteshwar Rural Municipality (गाउँपालिका)',
    'Sailung Rural Municipality (गाउँपालिका)',
    'Tamakoshi Rural Municipality (गाउँपालिका)',
    'Melung Rural Municipality (गाउँपालिका)',
    'Bigu Rural Municipality (गाउँपालिका)',
  ],
  'Kathmandu': [
    'Kathmandu Metropolitan City (महानगरपालिका)',
    'Kirtipur Municipality (नगरपालिका)',
    'Budhanilkantha Municipality (नगरपालिका)',
    'Chandragiri Municipality (नगरपालिका)',
    'Tokha Municipality (नगरपालिका)',
    'Nagarjun Municipality (नगरपालिका)',
    'Gokarneshwar Municipality (नगरपालिका)',
    'Tarakeshwar Municipality (नगरपालिका)',
    'Dakshinkali Municipality (नगरपालिका)',
    'Sankharapur Municipality (नगरपालिका)',
    'Kageshwari-Manohara Municipality (नगरपालिका)',
  ],
  'Kavrepalanchok': [
    'Dhulikhel Municipality (नगरपालिका)',
    'Banepa Municipality (नगरपालिका)',
    'Panauti Municipality (नगरपालिका)',
    'Panchkhal Municipality (नगरपालिका)',
    'Namobuddha Municipality (नगरपालिका)',
    'Mandandeupur Municipality (नगरपालिका)',
    'Roshi Rural Municipality (गाउँपालिका)',
    'Temal Rural Municipality (गाउँपालिका)',
    'Bhumlu Rural Municipality (गाउँपालिका)',
    'Mahabharat Rural Municipality (गाउँपालिका)',
    'Chaurideurali Rural Municipality (गाउँपालिका)',
    'Khanikhola Rural Municipality (गाउँपालिका)',
    'Bethanchowk Rural Municipality (गाउँपालिका)',
  ],
  'Lalitpur': [
    'Lalitpur Metropolitan City (महानगरपालिका)',
    'Mahalaxmi Municipality (नगरपालिका)',
    'Godawari Municipality (नगरपालिका)',
    'Konjyosom Rural Municipality (गाउँपालिका)',
    'Bagmati Rural Municipality (गाउँपालिका)',
    'Mahankal Rural Municipality (गाउँपालिका)',
  ],
  'Makwanpur': [
    'Hetauda Sub-Metropolitan City (उप-महानगरपालिका)',
    'Thaha Municipality (नगरपालिका)',
    'Bhimfedi Rural Municipality (गाउँपालिका)',
    'Makawanpurgadhi Rural Municipality (गाउँपालिका)',
    'Manahari Rural Municipality (गाउँपालिका)',
    'Raksirang Rural Municipality (गाउँपालिका)',
    'Bakaiya Rural Municipality (गाउँपालिका)',
    'Bagmati Rural Municipality (गाउँपालिका)',
    'Kailash Rural Municipality (गाउँपालिका)',
    'Indrasarowar Rural Municipality (गाउँपालिका)',
  ],
  'Nuwakot': [
    'Bidur Municipality (नगरपालिका)',
    'Belkotgadhi Municipality (नगरपालिका)',
    'Kakani Rural Municipality (गाउँपालिका)',
    'Panchakanya Rural Municipality (गाउँपालिका)',
    'Likhu Rural Municipality (गाउँपालिका)',
    'Samakhusi / Shivapuri Rural Municipality (गाउँपालिका)',
    'Tadi Rural Municipality (गाउँपालिका)',
    'Suryagadhi Rural Municipality (गाउँपालिका)',
    'Tarkeshwar Rural Municipality (गाउँपालिका)',
    'Kispang Rural Municipality (गाउँपालिका)',
    'Myagang Rural Municipality (गाउँपालिका)',
    'Dupcheshwar Rural Municipality (गाउँपालिका)',
  ],
  'Ramechhap': [
    'Manthali Municipality (नगरपालिका)',
    'Ramechhap Municipality (नगरपालिका)',
    'Khandadevi Rural Municipality (गाउँपालिका)',
    'Likhu Tamakoshi Rural Municipality (गाउँपालिका)',
    'Doramba Sailung Rural Municipality (गाउँपालिका)',
    'Gokulganga Rural Municipality (गाउँपालिका)',
    'Umakunda Rural Municipality (गाउँपालिका)',
    'Sunapati Rural Municipality (गाउँपालिका)',
  ],
  'Rasuwa': [
    'Uttargaya Rural Municipality (गाउँपालिका)',
    'Kalika Rural Municipality (गाउँपालिका)',
    'Gosaikunda Rural Municipality (गाउँपालिका)',
    'Naukunda Rural Municipality (गाउँपालिका)',
    'Aamachodingmo Rural Municipality (गाउँपालिका)',
  ],
  'Sindhuli': [
    'Kamalamai Municipality (नगरपालिका)',
    'Dudhuli Municipality (नगरपालिका)',
    'Sunkoshi Rural Municipality (गाउँपालिका)',
    'Hariharpurgadhi Rural Municipality (गाउँपालिका)',
    'Tinpatan Rural Municipality (गाउँपालिका)',
    'Marin Rural Municipality (गाउँपालिका)',
    'Golanjor Rural Municipality (गाउँपालिका)',
    'Phikkal Rural Municipality (गाउँपालिका)',
    'Ghyanglekh Rural Municipality (गाउँपालिका)',
  ],
  'Sindhupalchok': [
    'Chautara Sangachokgadhi Municipality (नगरपालिका)',
    'Melamchi Municipality (नगरपालिका)',
    'Barhabise Municipality (नगरपालिका)',
    'Indrawati Rural Municipality (गाउँपालिका)',
    'Panchpokhari Thangpal Rural Municipality (गाउँपालिका)',
    'Helambu Rural Municipality (गाउँपालिका)',
    'Jugal Rural Municipality (गाउँपालिका)',
    'Bhotekoshi Rural Municipality (गाउँपालिका)',
    'Sunkoshi Rural Municipality (गाउँपालिका)',
    'Balephi Rural Municipality (गाउँपालिका)',
    'Tripurasundari Rural Municipality (गाउँपालिका)',
    'Lisankhu Pakhar Rural Municipality (गाउँपालिका)',
  ],

  // PROVINCE 4: GANDAKI (11 Districts)
  'Baglung': [
    'Baglung Municipality (नगरपालिका)',
    'Galkot Municipality (नगरपालिका)',
    'Jaimini Municipality (नगरपालिका)',
    'Dhorpatan Municipality (नगरपालिका)',
    'Bareng Rural Municipality (गाउँपालिका)',
    'Kathekhola Rural Municipality (गाउँपालिका)',
    'Tamankhola Rural Municipality (गाउँपालिका)',
    'Tarakhola Rural Municipality (गाउँपालिका)',
    'Nisikhola Rural Municipality (गाउँपालिका)',
    'Badigad Rural Municipality (गाउँपालिका)',
  ],
  'Gorkha': [
    'Gorkha Municipality (नगरपालिका)',
    'Palungtar Municipality (नगरपालिका)',
    'Sulikot / Barpak Sulikot Rural Municipality (गाउँपालिका)',
    'Siranchok Rural Municipality (गाउँपालिका)',
    'Ajirkot Rural Municipality (गाउँपालिका)',
    'Aarughat Rural Municipality (गाउँपालिका)',
    'Gandaki Rural Municipality (गाउँपालिका)',
    'Bhimsenthapa Rural Municipality (गाउँपालिका)',
    'Shahid Lakhan Rural Municipality (गाउँपालिका)',
    'Dharche Rural Municipality (गाउँपालिका)',
    'Chumnubri Rural Municipality (गाउँपालिका)',
  ],
  'Kaski': [
    'Pokhara Metropolitan City (महानगरपालिका)',
    'Annapurna Rural Municipality (गाउँपालिका)',
    'Machhapuchhre Rural Municipality (गाउँपालिका)',
    'Madi Rural Municipality (गाउँपालिका)',
    'Rupa Rural Municipality (गाउँपालिका)',
  ],
  'Lamjung': [
    'Besisahar Municipality (नगरपालिका)',
    'Madhya Nepal Municipality (नगरपालिका)',
    'Rainas Municipality (नगरपालिका)',
    'Sundarbazar Municipality (नगरपालिका)',
    'Kwhlosothar Rural Municipality (गाउँपालिका)',
    'Dordi Rural Municipality (गाउँपालिका)',
    'Dudhpokhari Rural Municipality (गाउँपालिका)',
    'Marsyangdi Rural Municipality (गाउँपालिका)',
  ],
  'Manang': [
    'Chame Rural Municipality (गाउँपालिका)',
    'Nason Rural Municipality (गाउँपालिका)',
    'Narpa Bhumi Rural Municipality (गाउँपालिका)',
    'Manang Ngisyang Rural Municipality (गाउँपालिका)',
  ],
  'Mustang': [
    'Gharapjhong Rural Municipality (गाउँपालिका)',
    'Thasang Rural Municipality (गाउँपालिका)',
    'Baragung Muktichhetra Rural Municipality (गाउँपालिका)',
    'Lomanthang Rural Municipality (गाउँपालिका)',
    'Lo-Ghekar Damodarkunda Rural Municipality (गाउँपालिका)',
  ],
  'Myagdi': [
    'Beni Municipality (नगरपालिका)',
    'Annapurna Rural Municipality (गाउँपालिका)',
    'Dhaulagiri Rural Municipality (गाउँपालिका)',
    'Mangala Rural Municipality (गाउँपालिका)',
    'Malika Rural Municipality (गाउँपालिका)',
    'Raghuganga Rural Municipality (गाउँपालिका)',
  ],
  'Nawalpur (Nawalparasi East)': [
    'Kawasoti Municipality (नगरपालिका)',
    'Gaindakot Municipality (नगरपालिका)',
    'Devchuli Municipality (नगरपालिका)',
    'Madhyabindu Municipality (नगरपालिका)',
    'Baudikali Rural Municipality (गाउँपालिका)',
    'Bulingtar Rural Municipality (गाउँपालिका)',
    'Binayi Tribeni Rural Municipality (गाउँपालिका)',
    'Hupsekot Rural Municipality (गाउँपालिका)',
  ],
  'Parbat': [
    'Kushma Municipality (नगरपालिका)',
    'Phalebas Municipality (नगरपालिका)',
    'Jaljala Rural Municipality (गाउँपालिका)',
    'Paiyun Rural Municipality (गाउँपालिका)',
    'Mahashila Rural Municipality (गाउँपालिका)',
    'Modi Rural Municipality (गाउँपालिका)',
    'Bihadi Rural Municipality (गाउँपालिका)',
  ],
  'Syangja': [
    'Putalibazar Municipality (नगरपालिका)',
    'Waling Municipality (नगरपालिका)',
    'Chapakot Municipality (नगरपालिका)',
    'Bhimad / Galyang Municipality (नगरपालिका)',
    'Arjunchhaupari Rural Municipality (गाउँपालिका)',
    'Kaligandaki Rural Municipality (गाउँपालिका)',
    'Phedikhola Rural Municipality (गाउँपालिका)',
    'Harinas Rural Municipality (गाउँपालिका)',
    'Biruwa Rural Municipality (गाउँपालिका)',
    'Aandhikhola Rural Municipality (गाउँपालिका)',
  ],
  'Tanahun': [
    'Byas Municipality (नगरपालिका)',
    'Shuklagandaki Municipality (नगरपालिका)',
    'Bhimad Municipality (नगरपालिका)',
    'Bhanu Municipality (नगरपालिका)',
    'Anbukhaireni Rural Municipality (गाउँपालिका)',
    'Bandipur Rural Municipality (गाउँपालिका)',
    'Devghat Rural Municipality (गाउँपालिका)',
    'Myagde Rural Municipality (गाउँपालिका)',
    'Rishing Rural Municipality (गाउँपालिका)',
    'Ghiring Rural Municipality (गाउँपालिका)',
  ],

  // PROVINCE 5: LUMBINI (12 Districts)
  'Arghakhanchi': [
    'Sandhikharka Municipality (नगरपालिका)',
    'Shitaganga Municipality (नगरपालिका)',
    'Bhumikasthan Municipality (नगरपालिका)',
    'Chhatradev Rural Municipality (गाउँपालिका)',
    'Panini Rural Municipality (गाउँपालिका)',
    'Malarani Rural Municipality (गाउँपालिका)',
  ],
  'Banke': [
    'Nepalgunj Sub-Metropolitan City (उप-महानगरपालिका)',
    'Kohalpur Municipality (नगरपालिका)',
    'Narainapur Rural Municipality (गाउँपालिका)',
    'Rapti Sonari Rural Municipality (गाउँपालिका)',
    'Baijanath Rural Municipality (गाउँपालिका)',
    'Khajura Rural Municipality (गाउँपालिका)',
    'Duduwa Rural Municipality (गाउँपालिका)',
    'Janaki Rural Municipality (गाउँपालिका)',
  ],
  'Bardiya': [
    'Gulariya Municipality (नगरपालिका)',
    'Madhuwan Municipality (नगरपालिका)',
    'Rajapur Municipality (नगरपालिका)',
    'Thakurbaba Municipality (नगरपालिका)',
    'Bansgadhi Municipality (नगरपालिका)',
    'Barbardiya Municipality (नगरपालिका)',
    'Badhaiyatal Rural Municipality (गाउँपालिका)',
    'Geruwa Rural Municipality (गाउँपालिका)',
  ],
  'Dang': [
    'Ghorahi Sub-Metropolitan City (उप-महानगरपालिका)',
    'Tulsipur Sub-Metropolitan City (उप-महानगरपालिका)',
    'Lamahi Municipality (नगरपालिका)',
    'Gadhawa Rural Municipality (गाउँपालिका)',
    'Rajpur Rural Municipality (गाउँपालिका)',
    'Shantinagar Rural Municipality (गाउँपालिका)',
    'Sisne / Rapti Rural Municipality (गाउँपालिका)',
    'Banglachuli Rural Municipality (गाउँपालिका)',
    'Dangisharan Rural Municipality (गाउँपालिका)',
    'Babai Rural Municipality (गाउँपालिका)',
  ],
  'Gulmi': [
    'Tamghas / Resunga Municipality (नगरपालिका)',
    'Musikot Municipality (नगरपालिका)',
    'Isma Rural Municipality (गाउँपालिका)',
    'Kaligandaki Rural Municipality (गाउँपालिका)',
    'Gulmi Durbar Rural Municipality (गाउँपालिका)',
    'Satyawati Rural Municipality (गाउँपालिका)',
    'Chandrakot Rural Municipality (गाउँपालिका)',
    'Ruru Rural Municipality (गाउँपालिका)',
    'Chhatrakot Rural Municipality (गाउँपालिका)',
    'Dhurkot Rural Municipality (गाउँपालिका)',
    'Madane Rural Municipality (गाउँपालिका)',
    'Malika Rural Municipality (गाउँपालिका)',
  ],
  'Kapilvastu': [
    'Kapilvastu Municipality (नगरपालिका)',
    'Banganga Municipality (नगरपालिका)',
    'Buddhabhumi Municipality (नगरपालिका)',
    'Shivaraj Municipality (नगरपालिका)',
    'Krishnanagar Municipality (नगरपालिका)',
    'Maharajgunj Municipality (नगरपालिका)',
    'Mayadevi Rural Municipality (गाउँपालिका)',
    'Yashodhara Rural Municipality (गाउँपालिका)',
    'Suddhodhan Rural Municipality (गाउँपालिका)',
    'Bijaynagar Rural Municipality (गाउँपालिका)',
  ],
  'Palpa': [
    'Tansen Municipality (नगरपालिका)',
    'Rampur Municipality (नगरपालिका)',
    'Nishdi Rural Municipality (गाउँपालिका)',
    'Purwakhola Rural Municipality (गाउँपालिका)',
    'Rambha Rural Municipality (गाउँपालिका)',
    'Mathagadhi Rural Municipality (गाउँपालिका)',
    'Tinau Rural Municipality (गाउँपालिका)',
    'Bagnaskali Rural Municipality (गाउँपालिका)',
    'Ribdikot Rural Municipality (गाउँपालिका)',
    'Rainadevi Chhahara Rural Municipality (गाउँपालिका)',
  ],
  'Parasi (Nawalparasi West)': [
    'Ramgram Municipality (नगरपालिका)',
    'Sunwal Municipality (नगरपालिका)',
    'Bardaghat Municipality (नगरपालिका)',
    'Tribenisusta / Susta Rural Municipality (गाउँपालिका)',
    'Palhinandan Rural Municipality (गाउँपालिका)',
    'Pratappur Rural Municipality (गाउँपालिका)',
    'Sarawal Rural Municipality (गाउँपालिका)',
  ],
  'Pyuthan': [
    'Pyuthan Municipality (नगरपालिका)',
    'Swargadwari Municipality (नगरपालिका)',
    'Gaumukhi Rural Municipality (गाउँपालिका)',
    'Mandavi Rural Municipality (गाउँपालिका)',
    'Sarumarani Rural Municipality (गाउँपालिका)',
    'Mallarani Rural Municipality (गाउँपालिका)',
    'Naubahini Rural Municipality (गाउँपालिका)',
    'Jhimruk Rural Municipality (गाउँपालिका)',
    'Airawati Rural Municipality (गाउँपालिका)',
  ],
  'Rolpa': [
    'Liwang / Rolpa Municipality (नगरपालिका)',
    'Runtigadhi Rural Municipality (गाउँपालिका)',
    'Triveni Rural Municipality (गाउँपालिका)',
    'Sunil Smriti Rural Municipality (गाउँपालिका)',
    'Lungri Rural Municipality (गाउँपालिका)',
    'Duikholi / Paribartan Rural Municipality (गाउँपालिका)',
    'Thawang Rural Municipality (गाउँपालिका)',
    'Madi Rural Municipality (गाउँपालिका)',
    'Gajarul / Gangadev Rural Municipality (गाउँपालिका)',
    'Sukidaha Rural Municipality (गाउँपालिका)',
  ],
  'Rukum East': [
    'Bhume Rural Municipality (गाउँपालिका)',
    'Putha Uttarganga Rural Municipality (गाउँपालिका)',
    'Sisne Rural Municipality (गाउँपालिका)',
  ],
  'Rupandehi': [
    'Butwal Sub-Metropolitan City (उप-महानगरपालिका)',
    'Devdaha Municipality (नगरपालिका)',
    'Lumbini Sanskritik Municipality (नगरपालिका)',
    'Sainamaina Municipality (नगरपालिका)',
    'Siddharthanagar Municipality (नगरपालिका)',
    'Tilottama Municipality (नगरपालिका)',
    'Gaidahawa Rural Municipality (गाउँपालिका)',
    'Kanchan Rural Municipality (गाउँपालिका)',
    'Kothimai Rural Municipality (गाउँपालिका)',
    'Marchawari Rural Municipality (गाउँपालिका)',
    'Mayadevi Rural Municipality (गाउँपालिका)',
    'Omsatiya Rural Municipality (गाउँपालिका)',
    'Rohini Rural Municipality (गाउँपालिका)',
    'Sammarimai Rural Municipality (गाउँपालिका)',
    'Siyari Rural Municipality (गाउँपालिका)',
    'Suddhodhan Rural Municipality (गाउँपालिका)',
  ],

  // PROVINCE 6: KARNALI (10 Districts)
  'Dailekh': [
    'Narayan Municipality (नगरपालिका)',
    'Dullu Municipality (नगरपालिका)',
    'Chamunda Bindrasaini Municipality (नगरपालिका)',
    'Aathbis Municipality (नगरपालिका)',
    'Bhagawatimai Rural Municipality (गाउँपालिका)',
    'Gurans Rural Municipality (गाउँपालिका)',
    'Dungeshwar Rural Municipality (गाउँपालिका)',
    'Naumule Rural Municipality (गाउँपालिका)',
    'Mahabu Rural Municipality (गाउँपालिका)',
    'Bhairabi Rural Municipality (गाउँपालिका)',
    'Thantikandh Rural Municipality (गाउँपालिका)',
  ],
  'Dolpa': [
    'Thuli Bheri Municipality (नगरपालिका)',
    'Tripurasundari Municipality (नगरपालिका)',
    'Dolpo Buddha Rural Municipality (गाउँपालिका)',
    'Shey Phoksundo Rural Municipality (गाउँपालिका)',
    'Jagadulla Rural Municipality (गाउँपालिका)',
    'Mudkechula Rural Municipality (गाउँपालिका)',
    'Kaike Rural Municipality (गाउँपालिका)',
    'Chharka Tangsong Rural Municipality (गाउँपालिका)',
  ],
  'Humla': [
    'Simkot Rural Municipality (गाउँपालिका)',
    'Namkha Rural Municipality (गाउँपालिका)',
    'Kharpunath Rural Municipality (गाउँपालिका)',
    'Sarkegad Rural Municipality (गाउँपालिका)',
    'Chankheli Rural Municipality (गाउँपालिका)',
    'Adanchuli Rural Municipality (गाउँपालिका)',
    'Tajakot Rural Municipality (गाउँपालिका)',
  ],
  'Jajarkot': [
    'Bheri Municipality (नगरपालिका)',
    'Chhedagad Municipality (नगरपालिका)',
    'Nalgad Municipality (नगरपालिका)',
    'Kuse Rural Municipality (गाउँपालिका)',
    'Junichande Rural Municipality (गाउँपालिका)',
    'Barekot Rural Municipality (गाउँपालिका)',
    'Shivalaya Rural Municipality (गाउँपालिका)',
  ],
  'Jumla': [
    'Chandannath Municipality (नगरपालिका)',
    'Kankasundari Rural Municipality (गाउँपालिका)',
    'Sinja Rural Municipality (गाउँपालिका)',
    'Hima Rural Municipality (गाउँपालिका)',
    'Tila Rural Municipality (गाउँपालिका)',
    'Guthichaur Rural Municipality (गाउँपालिका)',
    'Tatopani Rural Municipality (गाउँपालिका)',
    'Patarasi Rural Municipality (गाउँपालिका)',
  ],
  'Kalikot': [
    'Manma / Khandachakra Municipality (नगरपालिका)',
    'Raskot Municipality (नगरपालिका)',
    'Tilagufa Municipality (नगरपालिका)',
    'Pachaljharana Rural Municipality (गाउँपालिका)',
    'Sanni Triveni Rural Municipality (गाउँपालिका)',
    'Naraharinath Rural Municipality (गाउँपालिका)',
    'Shubha Kalika Rural Municipality (गाउँपालिका)',
    'Mahawai Rural Municipality (गाउँपालिका)',
    'Palata Rural Municipality (गाउँपालिका)',
  ],
  'Mugu': [
    'Gamgadhi / Chhayanath Rara Municipality (नगरपालिका)',
    'Mugum Karmarong Rural Municipality (गाउँपालिका)',
    'Soru Rural Municipality (गाउँपालिका)',
    'Khatyad Rural Municipality (गाउँपालिका)',
  ],
  'Rukum West': [
    'Musikot Municipality (नगरपालिका)',
    'Chaurjahari Municipality (नगरपालिका)',
    'Aathbiskot Municipality (नगरपालिका)',
    'Banfikot Rural Municipality (गाउँपालिका)',
    'Tribeni Rural Municipality (गाउँपालिका)',
    'Sani Bheri Rural Municipality (गाउँपालिका)',
  ],
  'Salyan': [
    'Sharada Municipality (नगरपालिका)',
    'Bagchaur Municipality (नगरपालिका)',
    'Bangad Kupinde Municipality (नगरपालिका)',
    'Kalimati Rural Municipality (गाउँपालिका)',
    'Triveni Rural Municipality (गाउँपालिका)',
    'Kapurkot Rural Municipality (गाउँपालिका)',
    'Chatreshwari Rural Municipality (गाउँपालिका)',
    'Kumakh Rural Municipality (गाउँपालिका)',
    'Darma Rural Municipality (गाउँपालिका)',
    'Dhorchaur / Siddha Kumakh Rural Municipality (गाउँपालिका)',
  ],
  'Surkhet': [
    'Birendranagar Municipality (नगरपालिका)',
    'Bheriganga Municipality (नगरपालिका)',
    'Gurbhakot Municipality (नगरपालिका)',
    'Panchapuri Municipality (नगरपालिका)',
    'Lekbeshi Municipality (नगरपालिका)',
    'Chaukune Rural Municipality (गाउँपालिका)',
    'Barahatal Rural Municipality (गाउँपालिका)',
    'Chingad Rural Municipality (गाउँपालिका)',
    'Simta Rural Municipality (गाउँपालिका)',
  ],

  // PROVINCE 7: SUDURPASHCHIM (9 Districts)
  'Achham': [
    'Mangalsen Municipality (नगरपालिका)',
    'Sanfebagar Municipality (नगरपालिका)',
    'Kamalbazar Municipality (नगरपालिका)',
    'Panchadewal Binayak Municipality (नगरपालिका)',
    'Chaurpati Rural Municipality (गाउँपालिका)',
    'Mellekh Rural Municipality (गाउँपालिका)',
    'Bannigadhi Jayagadh Rural Municipality (गाउँपालिका)',
    'Ramaroshan Rural Municipality (गाउँपालिका)',
    'Dhankari / Dhakari Rural Municipality (गाउँपालिका)',
    'Turmakhand Rural Municipality (गाउँपालिका)',
  ],
  'Baitadi': [
    'Dasharathchand Municipality (नगरपालिका)',
    'Patan Municipality (नगरपालिका)',
    'Melauli Municipality (नगरपालिका)',
    'Purchaudi Municipality (नगरपालिका)',
    'Sunary / Sunarya Rural Municipality (गाउँपालिका)',
    'Sigas Rural Municipality (गाउँपालिका)',
    'Shivanath Rural Municipality (गाउँपालिका)',
    'Pancheshwar Rural Municipality (गाउँपालिका)',
    'Dogadakedar Rural Municipality (गाउँपालिका)',
    'Dilasaini Rural Municipality (गाउँपालिका)',
  ],
  'Bajhang': [
    'Jayaprithvi Municipality (नगरपालिका)',
    'Bungal Municipality (नगरपालिका)',
    'Talkot Rural Municipality (गाउँपालिका)',
    'Masta Rural Municipality (गाउँपालिका)',
    'Khaptadchhanna Rural Municipality (गाउँपालिका)',
    'Thalara Rural Municipality (गाउँपालिका)',
    'Bitthadchir Rural Municipality (गाउँपालिका)',
    'Surma Rural Municipality (गाउँपालिका)',
    'Chhabispathibhera Rural Municipality (गाउँपालिका)',
    'Durgathali Rural Municipality (गाउँपालिका)',
    'Kedarsyu Rural Municipality (गाउँपालिका)',
    'Saipal Rural Municipality (गाउँपालिका)',
  ],
  'Bajura': [
    'Badimalika Municipality (नगरपालिका)',
    'Triveni Municipality (नगरपालिका)',
    'Budhiganga Municipality (नगरपालिका)',
    'Budhinanda Municipality (नगरपालिका)',
    'Gaumul Rural Municipality (गाउँपालिका)',
    'Pandavgufa / Jagannath Rural Municipality (गाउँपालिका)',
    'Swami Kartik Khapar Rural Municipality (गाउँपालिका)',
    'Chhededaha / Khaptad Chhededaha Rural Municipality (गाउँपालिका)',
    'Himali Rural Municipality (गाउँपालिका)',
  ],
  'Dadeldhura': [
    'Amargadhi Municipality (नगरपालिका)',
    'Parshuram Municipality (नगरपालिका)',
    'Aalital Rural Municipality (गाउँपालिका)',
    'Bhageshwar Rural Municipality (गाउँपालिका)',
    'Navadurga Rural Municipality (गाउँपालिका)',
    'Ajayameru Rural Municipality (गाउँपालिका)',
    'Ganyapdhura Rural Municipality (गाउँपालिका)',
  ],
  'Darchula': [
    'Khalanga / Mahakali Municipality (नगरपालिका)',
    'Shailyashikhar Municipality (नगरपालिका)',
    'Malikarjun Rural Municipality (गाउँपालिका)',
    'Apihimal Rural Municipality (गाउँपालिका)',
    'Duhun Rural Municipality (गाउँपालिका)',
    'Naugad Rural Municipality (गाउँपालिका)',
    'Marma Rural Municipality (गाउँपालिका)',
    'Lekam Rural Municipality (गाउँपालिका)',
    'Byas Rural Municipality (गाउँपालिका)',
  ],
  'Doti': [
    'Dipayal Silgadhi Municipality (नगरपालिका)',
    'Shikhar Municipality (नगरपालिका)',
    'Purbichauki Rural Municipality (गाउँपालिका)',
    'Badikedar Rural Municipality (गाउँपालिका)',
    'Jorayal Rural Municipality (गाउँपालिका)',
    'Sayal Rural Municipality (गाउँपालिका)',
    'Aadarsha Rural Municipality (गाउँपालिका)',
    'Dr. K.I. Singh Rural Municipality (गाउँपालिका)',
    'Bogatan-Phudsil Rural Municipality (गाउँपालिका)',
  ],
  'Kailali': [
    'Dhangadhi Sub-Metropolitan City (उप-महानगरपालिका)',
    'Tikapur Municipality (नगरपालिका)',
    'Ghodaghodi Municipality (नगरपालिका)',
    'Lamki Chuha Municipality (नगरपालिका)',
    'Bhajani Municipality (नगरपालिका)',
    'Godawari Municipality (नगरपालिका)',
    'Gauriganga Municipality (नगरपालिका)',
    'Janaki Rural Municipality (गाउँपालिका)',
    'Bardagoriya Rural Municipality (गाउँपालिका)',
    'Mohanyal Rural Municipality (गाउँपालिका)',
    'Kailari Rural Municipality (गाउँपालिका)',
    'Joshipur Rural Municipality (गाउँपालिका)',
    'Chure Rural Municipality (गाउँपालिका)',
  ],
  'Kanchanpur': [
    'Bhimdatta Municipality (नगरपालिका)',
    'Bedkot Municipality (नगरपालिका)',
    'Shuklaphanta Municipality (नगरपालिका)',
    'Mahakali Municipality (नगरपालिका)',
    'Krishnapur Municipality (नगरपालिका)',
    'Punarbash Municipality (नगरपालिका)',
    'Belauri Municipality (नगरपालिका)',
    'Laljhadi Rural Municipality (गाउँपालिका)',
    'Beldandi Rural Municipality (गाउँपालिका)',
  ],
};

// ==========================================
// FLUTTER PROFILE SCREEN WIDGET
// ==========================================
class ProfileScreen extends StatefulWidget {
  final bool isNe;
  const ProfileScreen({super.key, required this.isNe});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;

  // Personal Info
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Address Info
  String? _selectedDistrict;
  String? _selectedMunicipality;
  List<String> _availableMunicipalities = [];
  final TextEditingController _wardController = TextEditingController();

  // Emergency Contact
  final TextEditingController _emergencyContactNameController = TextEditingController();
  final TextEditingController _emergencyContactPhoneController = TextEditingController();
  String _emergencyRelation = 'Parent (आमा/बुवा)';

  // Medical Info
  String _selectedBloodGroup = 'A+';
  bool _hasDisability = false;
  final TextEditingController _disabilityNotesController = TextEditingController();

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final List<String> _relations = [
    'Parent (आमा/बुवा)',
    'Spouse (श्रीमान/श्रीमती)',
    'Sibling (दाजु/भाइ/दिदी/बहिनी)',
    'Child (छोरा/छोरी)',
    'Friend (साथी)',
    'Relative / Other (नातेदार/अन्य)'
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _wardController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _disabilityNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      _phoneController.text = prefs.getString('user_phone') ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
      _wardController.text = prefs.getString('user_ward') ?? '';

      // Load District & Municipalities
      final savedDistrict = prefs.getString('user_district');
      if (savedDistrict != null && nepalAdministrativeData.containsKey(savedDistrict)) {
        _selectedDistrict = savedDistrict;
        _availableMunicipalities = nepalAdministrativeData[savedDistrict] ?? [];

        final savedMunicipality = prefs.getString('user_municipality');
        if (savedMunicipality != null && _availableMunicipalities.contains(savedMunicipality)) {
          _selectedMunicipality = savedMunicipality;
        }
      }

      _emergencyContactNameController.text = prefs.getString('emergency_name') ?? '';
      _emergencyContactPhoneController.text = prefs.getString('emergency_phone') ?? '';
      _emergencyRelation = prefs.getString('emergency_relation') ?? _relations.first;

      _selectedBloodGroup = prefs.getString('user_blood_group') ?? 'A+';
      _hasDisability = prefs.getBool('user_has_disability') ?? false;
      _disabilityNotesController.text = prefs.getString('user_disability_notes') ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveProfileData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_name', _nameController.text.trim());
    await prefs.setString('user_phone', _phoneController.text.trim());
    await prefs.setString('user_email', _emailController.text.trim());
    await prefs.setString('user_district', _selectedDistrict ?? '');
    await prefs.setString('user_municipality', _selectedMunicipality ?? '');
    await prefs.setString('user_ward', _wardController.text.trim());

    await prefs.setString('emergency_name', _emergencyContactNameController.text.trim());
    await prefs.setString('emergency_phone', _emergencyContactPhoneController.text.trim());
    await prefs.setString('emergency_relation', _emergencyRelation);

    await prefs.setString('user_blood_group', _selectedBloodGroup);
    await prefs.setBool('user_has_disability', _hasDisability);
    await prefs.setString('user_disability_notes', _disabilityNotesController.text.trim());

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.isNe ? 'तपाईंको प्रोफाइल विवरण सुरक्षित भयो!' : 'Emergency Profile Saved!',
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;
    final sortedDistricts = nepalAdministrativeData.keys.toList()..sort();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'आपत्कालीन प्रोफाइल' : 'Emergency Profile',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                children: [
                  // Info Notice Box
                  _buildNoticeBanner(isNe),
                  const SizedBox(height: 16),

                  // 1. Personal Details Card
                  _buildSectionCard(
                    title: isNe ? 'व्यक्तिगत विवरण (Personal Details)' : 'Personal Details',
                    icon: Icons.person_rounded,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: isNe ? 'पूरा नाम (Full Name) *' : 'Full Name *',
                        hint: 'John Doe',
                        prefixIcon: Icons.badge_outlined,
                        isRequired: true,
                      ),
                      _buildTextField(
                        controller: _phoneController,
                        label: isNe ? 'फोन नम्बर (Phone Number) *' : 'Phone Number *',
                        hint: '98XXXXXXXX',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        isRequired: true,
                      ),
                      _buildTextField(
                        controller: _emailController,
                        label: isNe ? 'इमेल (Email)' : 'Email',
                        hint: 'example@mail.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. Address Details Card (Cascading 77 Districts)
                  _buildSectionCard(
                    title: isNe ? 'ठेगाना विवरण (Address Details)' : 'Address Details',
                    icon: Icons.location_on_rounded,
                    children: [
                      _buildSearchableDropdown(
                        label: isNe ? 'जिल्ला (District) *' : 'District *',
                        hint: isNe ? 'जिल्ला छान्नुहोस्' : 'Select District',
                        value: _selectedDistrict,
                        prefixIcon: Icons.map_outlined,
                        items: sortedDistricts,
                        isRequired: true,
                        onChanged: (district) {
                          setState(() {
                            _selectedDistrict = district;
                            _availableMunicipalities = nepalAdministrativeData[district] ?? [];
                            _selectedMunicipality = null; // Clear previous municipality
                          });
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: _buildSearchableDropdown(
                              label: isNe ? 'पालिका (Municipality/गा.पा.) *' : 'Municipality / Ga.Pa. *',
                              hint: _selectedDistrict == null
                                  ? (isNe ? 'पहिले जिल्ला छान्नुहोस्' : 'Pick District 1st')
                                  : (isNe ? 'पालिका छान्नुहोस्' : 'Select Local Body'),
                              value: _selectedMunicipality,
                              prefixIcon: Icons.apartment_outlined,
                              items: _availableMunicipalities,
                              isRequired: true,
                              enabled: _selectedDistrict != null,
                              onChanged: (municipality) {
                                setState(() => _selectedMunicipality = municipality);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: _buildTextField(
                              controller: _wardController,
                              label: isNe ? 'वडा नं *' : 'Ward No *',
                              hint: '1',
                              isRequired: true,
                              prefixIcon: Icons.tag_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3. Emergency Contact Card
                  _buildSectionCard(
                    title: isNe ? 'आकस्मिक सम्पर्क (Emergency Contact)' : 'Emergency Contact',
                    icon: Icons.contact_emergency_rounded,
                    children: [
                      _buildTextField(
                        controller: _emergencyContactNameController,
                        label: isNe ? 'सम्पर्क व्यक्तिको नाम *' : 'Contact Person Name *',
                        prefixIcon: Icons.person_outline_rounded,
                        isRequired: true,
                      ),
                      _buildTextField(
                        controller: _emergencyContactPhoneController,
                        label: isNe ? 'सम्पर्क फोन नम्बर *' : 'Contact Phone Number *',
                        prefixIcon: Icons.phone_forwarded_outlined,
                        keyboardType: TextInputType.phone,
                        isRequired: true,
                      ),
                      _buildSearchableDropdown(
                        label: isNe ? 'नाता / सम्बन्ध (Relationship)' : 'Relationship',
                        hint: 'Select Relationship',
                        value: _emergencyRelation,
                        prefixIcon: Icons.people_outline_rounded,
                        items: _relations,
                        onChanged: (val) => setState(() => _emergencyRelation = val!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. Medical Details Card
                  _buildSectionCard(
                    title: isNe ? 'स्वास्थ्य तथा अवस्था (Medical & Needs)' : 'Medical & Accessibility',
                    icon: Icons.medical_services_rounded,
                    children: [
                      _buildSearchableDropdown(
                        label: isNe ? 'रक्त समूह (Blood Group)' : 'Blood Group',
                        hint: 'Select Blood Group',
                        value: _selectedBloodGroup,
                        prefixIcon: Icons.bloodtype_outlined,
                        items: _bloodGroups,
                        onChanged: (val) => setState(() => _selectedBloodGroup = val!),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SwitchListTile.adaptive(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          title: Text(
                            isNe ? 'अशक्तता / विशेष हेरचाह आवश्यक?' : 'Disability / Special Needs?',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          activeColor: const Color(0xFFDC2626),
                          value: _hasDisability,
                          onChanged: (val) => setState(() => _hasDisability = val),
                        ),
                      ),
                      if (_hasDisability)
                        _buildTextField(
                          controller: _disabilityNotesController,
                          label: isNe ? 'आवश्यक विवरण' : 'Assistance Details',
                          hint: isNe ? 'उदा: ह्वीलचेयर, दृष्टिविहीन' : 'e.g., wheelchair, visual assistance',
                          prefixIcon: Icons.accessible_forward_rounded,
                          maxLines: 2,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Save Action Button
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                    ),
                    onPressed: _isSaving ? null : _saveProfileData,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            isNe ? 'विवरण सुरक्षित गर्नुहोस् (SAVE)' : 'SAVE EMERGENCY PROFILE',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
                          ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildNoticeBanner(bool isNe) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: Color(0xFF2563EB), size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isNe
                  ? 'यो विवरण SOS थिच्दा मात्र उद्धार टोली, परिवार र ५ कि.मि वरपरका सहयोगीहरूलाई पठाइनेछ।'
                  : 'This info is used exclusively for instant auto-dispatching during SOS activations.',
              style: const TextStyle(fontSize: 12, color: Color(0xFF1E40AF), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFFDC2626)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? prefixIcon,
    bool isRequired = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: isRequired ? (val) => (val == null || val.trim().isEmpty) ? 'Required' : null : null,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20, color: const Color(0xFF64748B)) : null,
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEF4444)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchableDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? prefixIcon,
    bool isRequired = false,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        isExpanded: true,
        validator: isRequired ? (val) => (val == null || val.isEmpty) ? 'Required' : null : null,
        style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20, color: const Color(0xFF64748B)) : null,
          filled: true,
          fillColor: enabled ? const Color(0xFFF8FAFC) : const Color(0xFFF1F5F9),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEF4444)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          ),
        ),
        items: enabled
            ? items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis),
                );
              }).toList()
            : [],
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}