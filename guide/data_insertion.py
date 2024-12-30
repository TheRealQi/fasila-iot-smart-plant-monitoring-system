from guide.models import Disease, ChemicalControl, Plant, PlantDisease

diseases_data = [
    {
        "name": "Anthracnose",
        "type": "fungal",
        "description": "A serious fungal disease that affects various plant parts including leaves, stems, and fruits. It creates dark, sunken lesions with raised edges and can severely impact crop yield and quality.",
        "spread": "Spreads through water splashes, contaminated tools, and infected plant debris. The fungus can survive in soil and plant debris between growing seasons. High humidity and temperatures between 20-30°C favor disease development.",
        "symptoms": [
            "Dark, sunken lesions with raised edges on fruits",
            "Circular or angular dark spots on leaves, typically 5-10 mm in diameter",
            "Small, water-soaked spots that enlarge and darken",
            "Stem lesions that can girdle young plants",
            "Wilting and death of affected leaves"
        ],
        "causes": [
            "Fungal pathogens of the genus Colletotrichum",
            "High humidity (above 80%)",
            "Prolonged leaf wetness",
        ],
        "cultural_control": [
            "Remove and destroy infected plant parts",
            "Maintain proper plant spacing for good air circulation",
            "Rotate crops with non-susceptible plants",
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Maintain sanitation",
            "Avoid working with wet plants",
            "Use resistant varieties when available",
            "Apply balanced fertilization"
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/anthracnose/anthracnose1.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/anthracnose/anthracnose2.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/anthracnose/anthracnose3.webp"
        ]
    },
    {
        "name": "Bacterial Blight",
        "type": "bacterial",
        "description": "A severe bacterial disease that affects the vascular system of plants, causing rapid wilting and death. The disease is particularly devastating as infected plants rarely recover.",
        "spread": "Spreads through contaminated seeds, tools, and irrigation water. The bacteria can survive in soil and plant debris for extended periods. Warm and humid conditions favor disease development.",
        "symptoms": [
            "Water-soaked lesions on leaves",
            "Yellowing or browning of leaves",
            "Wilting and death of affected plants",
            "Black or brown discoloration on stems",
            "Stunted growth",
        ],
        "causes": [
            "Ralstonia solanacearum bacteria",
            "High soil moisture",
            "Presence of root wounds",
            "Previous crop infection in soil"
        ],
        "cultural_control": [
            "Remove and destroy infected plants completely",
            "Sanitize tools and equipment",
            "Crop rotation with non-susceptible plants",
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Avoid working with wet plants",
            "Maintain proper plant spacing",
            "Use resistant varieties when available",
            "Apply balanced fertilization"
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/bacterial_wilt/bacterial_wilt1.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/bacterial_wilt/bacterial_wilt2.webp"
        ]
    },
    {
        "name": "Downy Mildew",
        "type": "fungal",
        "description": "A common fungal disease that affects a wide range of plants, causing yellowing, wilting, and death. The disease thrives in cool, humid conditions and can spread rapidly in favorable environments.",
        "spread": "Spreads through airborne spores, splashing water, and contaminated soil. The pathogen requires high humidity and moderate temperatures for infection. Can spread rapidly in cool, wet conditions.",
        "symptoms": [
            "Yellow to pale green patches on upper leaf surfaces",
            "White to grayish fuzzy growth on lower leaf surfaces",
            "Angular lesions bounded by leaf veins",
            "Stunted plant growth",
            "Leaf curling and distortion"
        ],
        "causes": [
            "Pseudoperonospora cubensis fungus",
            "High humidity (above 85%)",
            "Poor air circulation",
            "Extended periods of leaf wetness"
        ],
        "cultural_control": [
            "Improve air circulation between plants",
            "Remove infected plant parts immediately",
            "Prune weeds that may harbor the pathogen"
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Maintain proper plant spacing",
            "Apply balanced fertilization",
            "Use resistant varieties when available"
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/downy_mildew/downy_midlew2.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/downy_mildew/downy_midlew1.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/downy_mildew/downy_midlew3.webp"
        ]
    },
    {
        "name": "Gummy Stem Blight",
        "type": "fungal",
        "description": "A fungal disease that affects stems, leaves, and fruits of cucurbit plants. It can cause significant yield losses and plant death if left untreated.",
        "spread": "Spreads through infected seeds, plant debris, and splashing water. The fungus can survive on crop residue and can be carried on equipment and tools.",
        "symptoms": [
            "Dark brown to black lesions on stems",
            "Gummy, brown ooze from stem lesions",
            "Circular leaf spots with concentric rings",
            "Wilting of individual runners or entire plant",
            "Fruit rot with dark, sunken lesions"
        ],
        "causes": [
            "Didymella bryoniae fungus",
            "High humidity",
            "Extended periods of leaf wetness",
        ],
        "cultural_control": [
            "Remove and destroy infected plant parts",
            "Rotate crops with non-susceptible plants",
            "Maintain proper plant spacing",
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Apply balanced fertilization",
            "Use resistant varieties when available"
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/gummy_stem_blight/gummy_stem_blight1.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/gummy_stem_blight/gummy_stem_blight2.webp"
        ]
    },
    {
        "name": "Bacterial Spot",
        "type": "bacterial",
        "description": "A bacterial disease that affects leaves, fruits, and stems. It can cause significant crop losses, especially in warm, wet conditions.",
        "spread": "Spreads through infected seeds, transplants, and rain splash. Wind-driven rain can spread bacteria between plants and fields.",
        "symptoms": [
            "Small, dark, water-soaked spots on leaves (1-3 mm)",
            "Spots become angular and turn brown to black",
            "Yellow halos around leaf spots",
            "Raised, scabby spots on fruits",
            "Defoliation in severe cases"
        ],
        "causes": [
            "Xanthomonas species bacteria",
            "High humidity",
            "Prolonged leaf wetness",
        ],
        "cultural_control": [
            "Remove and destroy infected plant parts",
            "Sanitize tools and equipment",
            "Maintain proper plant spacing for good air circulation",
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Avoid working with wet plants",
            "Use resistant varieties when available",
            "Apply balanced fertilization"
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/bacterial_spot/bacterial_spot1.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/bacterial_spot/bacterial_spot2.webp"
        ]
    },
    {
        "name": "Early Blight",
        "type": "fungal",
        "description": "A common fungal disease that primarily affects leaves, stems, and fruits. It typically starts on older leaves and can cause significant defoliation and yield reduction.",
        "spread": "Spreads through wind, rain splash, and contaminated tools. The fungus overwinters in infected plant debris and can survive in soil for several years.",
        "symptoms": [
            "Dark brown spots with concentric rings (target-like pattern)",
            "Yellowing around leaf spots",
            "Spots initially 3-12 mm in diameter",
            "Stem lesions that are dark, sunken and often enlarge to form cankers",
            "Fruit lesions typically occur at the stem end"
        ],
        "causes": [
            "Alternaria solani fungus",
            "High humidity",
            "Alternating wet and dry conditions",
            "Stressed or aging plants"
        ],
        "cultural_control": [
            "Remove and destroy infected plant parts",
            "Sanitize tools and equipment",
            "Maintain proper plant spacing for good air circulation",
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Use resistant varieties when available",
            "Rotate crops with non-susceptible plants",
            "Use resistant varieties when available",
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/early_blight/early_blight2.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/early_blight/early_blight3.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/early_blight/early_blight1.webp"
        ],
    },
    {
        "name": "Late Blight",
        "type": "fungal",
        "description": "A highly destructive fungal disease that can destroy entire fields within days under favorable conditions. It affects leaves, stems, and fruits, and is infamous for causing the Irish potato famine.",
        "spread": "Spreads rapidly through wind-blown spores, especially in cool, wet weather. Can travel long distances and infect new areas quickly.",
        "symptoms": [
            "Large, dark brown to purplish-black lesions on leaves",
            "White fuzzy growth on leaf undersides in humid conditions",
            "Water-soaked areas on stems, typically 2-10 cm long",
            "Brown to purplish lesions on fruits",
            "Rapid plant collapse in severe cases"
        ],
        "causes": [
            "Phytophthora infestans fungus",
            "Relative humidity above 90%",
            "Free water on plant surfaces",
            "Cloudy, wet weather conditions"
        ],
        "cultural_control": [
            "Remove and destroy infected plant parts immediately",
            "Sanitize tools and equipment",
            "Maintain proper plant spacing for good air circulation",
            "Destry nightshade weeds"
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Apply balanced fertilization",
            "Use resistant varieties when available",
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/late_blight/late_blight1.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/late_blight/late_blight2.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/late_blight/late_blight3.webp"
        ]
    },
    {
        "name": "Leaf Mold",
        "type": "fungal",
        "description": "A fungal disease that primarily affects leaves, reducing photosynthetic capacity and yield. Particularly problematic in greenhouse production.",
        "spread": "Spreads through wind, rain splash, and contaminated tools. The fungus thrives in high humidity and moderate temperatures.",
        "symptoms": [
            "Yellow to pale green patches on upper leaf surfaces",
            "White to grayish fuzzy growth on lower leaf surfaces",
            "Angular lesions bounded by leaf veins",
            "Stunted plant growth",
            "Leaf curling and distortion"
        ],
        "causes": [
            "Fulvia fulva fungus",
            "High humidity (above 85%)",
            "Poor air circulation",
            "Extended periods of leaf wetness"
        ],
        "cultural_control": [
            "Improve air circulation between plants",
            "Remove infected plant parts immediately",
            "Prune weeds that may harbor the pathogen"
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Maintain proper plant spacing",
            "Apply balanced fertilization",
            "Use resistant varieties when available"
        ],
        "imgs_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/leaf_mold/leaf_mold1.jpg"
        ]
    },
    {
        "name": "Septoria Leaf Spot",
        "type": "fungal",
        "description": "A common fungal disease that primarily affects tomatoes, causing severe defoliation and reduced yields.",
        "spread": "Spreads through wind, rain splash, and contaminated tools. The fungus thrives in high humidity and moderate temperatures.",
        "symptoms": [
            "Small circular spots with dark brown margins",
            "Gray or white centers in spots with black dots (pycnidia)",
            "Spots usually 2-3 mm in diameter",
            "Lower leaves affected first",
            "Severe leaf yellowing and dropping"
        ],
        "causes": [
            "Septoria lycopersici fungus",
            "High humidity",
            "Poor air circulation"
        ],
        "cultural_control": [
            "Remove and destroy infected plant parts",
            "Sanitize tools and equipment",
            "Maintain proper plant spacing for good air circulation",
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Use resistant varieties when available",
            "Rotate crops with non-susceptible plants",
            "Maintain proper plant spacing for good air circulation",
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/septoria_leaf_spot/septoria_leaf_spot1.webp",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/septoria_leaf_spot/septoria_leaf_spot2.webp"
        ]
    },
    {
        "name": "Target Spot",
        "type": "fungal",
        "description": "A fungal disease that affects a wide range of plants, causing circular lesions with distinct rings. It can reduce photosynthesis and yield if left untreated.",
        "spread": "Spreads through wind, rain splash, and contaminated tools. The fungus thrives in high humidity and moderate temperatures.",
        "symptoms": [
            "Circular lesions with dark margins and concentric rings",
            "Lesions typically 1-5 cm in diameter",
            "Yellow halos around lesions",
            "Lesions may coalesce",
            "Severe defoliation in severe cases"
        ],
        "causes": [
            "Cercospora species fungus",
            "High humidity",
            "Poor air circulation",
            "Extended periods of leaf wetness"
        ],
        "cultural_control": [
            "Remove and destroy infected plant parts",
            "Sanitize tools and equipment",
            "Maintain proper plant spacing for good air circulation",
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Maintain proper plant spacing",
            "Apply balanced fertilization",
            "Use resistant varieties when available"
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/target_spot/target_spot2.jpg",
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/target_spot/target_spot1.jpg"
        ]
    },
    {
        "name": "Yellow Leaf Curl Virus",
        "type": "viral",
        "description": "A group of viruses that cause yellowing, curling, and stunting of leaves. The viruses are transmitted by whiteflies and can cause significant yield losses.",
        "spread": "Spreads through whitefly vectors, infected seeds, and contaminated tools. The viruses can overwinter in perennial hosts and weeds.",
        "symptoms": [
            "Yellowing and curling of leaves",
            "Stunted plant growth",
            "Reduced yields and fruit quality",
            "Leaf distortion and curling",
            "Yellowing of leaf veins"
        ],
        "causes": [
            "Various viruses including Tomato yellow leaf curl virus, Tomato mottle virus, and Tomato chlorosis virus",
            "Whitefly vectors",
            "Infected seeds",
            "Contaminated tools and equipment"
        ],
        "cultural_control": [
            "Remove and completely destroy infected plants",
            "Control whitefly vectors",
            "Sanitize tools and equipment",
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Control whitefly vectors",
            "Use resistant varieties when available",
            "Clean and sanitize tools and equipment regularly"
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/yellow_leaf_curl_virus/yellow_leaf_curl_virus1.jpg"
        ]
    },
    {
        "name": "Mosaic Virus",
        "type": "viral",
        "description": "A group of viruses that cause mosaic patterns on leaves, stunted growth, and reduced yields. The viruses are transmitted by insects, contaminated tools, and infected seeds.",
        "spread": "Spreads through insect vectors, contaminated tools, and infected seeds. The viruses can overwinter in perennial hosts and weeds.",
        "symptoms": [
            "Mottled light and dark green patterns on leaves",
            "Yellow or white streaking on leaves",
            "Stunted plant growth",
            "Leaf distortion and curling",
            "Reduced yields and fruit quality",
            "Yellowing of leaf veins"
        ],
        "causes": [
            "Various viruses including Tobacco mosaic virus, Cucumber mosaic virus, and Tomato mosaic virus",
            "Insect vectors (aphids, whiteflies, thrips)",
            "Contaminated tools and equipment",
            "Infected seeds"
        ],
        "cultural_control": [
            "Remove and completely destroy infected plants",
            "Control insect vectors",
            "Sanitize tools and equipment",
        ],
        "prevention": [
            "Use disease-free seeds and transplants",
            "Control insect vectors",
            "Use resistant varieties when available",
            "Clean and sanitize tools and equipment regularly"
        ],
        "image_urls": [
            "https://fasila.s3.eu-central-1.amazonaws.com/Images_WEBP/diseases/mosaic_virus/mosaic_virus1.jpg"
        ]
    },
]

for disease in diseases_data:
    Disease.objects.create(
        name=disease["name"],
        type=disease["type"],
        description=disease["description"],
        spread=disease["spread"],
        symptoms=disease["symptoms"],
        causes=disease["causes"],
        cultural_control=disease["cultural_control"],
        prevention=disease["prevention"],
        image_urls=disease.get("image_urls", [])
    )

from guide.models import Disease, ChemicalControl

chemical_controls = [
    {
        "name": "Carbenzadim 50% WP",
        # Anthracnose, Downy Mildew, Gummy Stem Blight, Early Blight, Late Blight, Leaf Mold, Septoria Leaf Spot, Target Spot
        "type": "Fungicide",
        "active_ingredients": "Carbenzadim",
        "application_methods": [
            "Spray the Fungicide on the plant leaves and stems ensuring complete coverage.",
            "Could apply the Fungicide as a preventive measure during warm and humid weather conditions.",
            "Repeat the application every 7-14 days for a maximum of 4 times or as per the manufacturer's instructions."
        ]
    },
    {
        "name": "Mancozeb 75% WG",
        # Anthracnose, Downy Mildew, Gummy Stem Blight, Early Blight, Late Blight, Leaf Mold, Septoria Leaf Spot, Target Spot
        "type": "Fungicide",
        "active_ingredients": "Mancozeb",
        "application_methods": [
            "Prepare a spray solution by mixing Mancozeb with water as per the label's recommended dosage.",
            "Spray thoroughly on leaves and stems, ensuring even coverage.",
            "Apply at 7-10 day intervals during active disease periods or as a preventive measure."
        ]
    },
    {
        "name": "Copper Oxychloride 50% WP",
        # Anthracnose, Bacterial Spot, Gummy Stem Blight, Septoria Leaf Spot, Late Blight
        "type": "Fungicide/Bactericide",
        "active_ingredients": "Copper Oxychloride",
        "application_methods": [
            "Mix Copper Oxychloride with water as directed on the product label.",
            "Spray on leaves and stems to provide a protective coating against fungal and bacterial infections.",
            "Reapply every 7-14 days or after heavy rains."
        ]
    },
    {
        "name": "Azoxystrobin 23% SC",  # Anthracnose, Early Blight, Target Spot, Septoria Leaf Spot, Leaf Mold
        "type": "Fungicide",
        "active_ingredients": "Azoxystrobin",
        "application_methods": [
            "Dilute the product in water as per the manufacturer's recommendations.",
            "Apply as a foliar spray ensuring thorough coverage of leaves and stems.",
            "Repeat applications every 10-14 days for ongoing protection during the growing season."
        ]
    },
    {
        "name": "Metalaxyl-M 40% WP",  # Downy Mildew, Late Blight
        "type": "Fungicide",
        "active_ingredients": "Metalaxyl-M",
        "application_methods": [
            "Mix the Fungicide in water according to the recommended dosage on the product label.",
            "Apply to the foliage and base of plants as a preventive or curative measure.",
            "Reapply every 7-14 days depending on disease pressure."
        ]
    },
    {
        "name": "Chlorothalonil 75% WP",
        # Anthracnose, Downy Mildew, Gummy Stem Blight, Early Blight, Late Blight, Leaf Mold, Septoria Leaf Spot, Target Spot
        "type": "Fungicide",
        "active_ingredients": "Chlorothalonil",
        "application_methods": [
            "Mix Chlorothalonil with water as per the recommended dosage on the label.",
            "Spray thoroughly on all parts of the plant, especially the leaves and stems.",
            "Repeat applications every 7-10 days or after rain."
        ]
    },
    {
        "name": "Thiophanate-methyl 50% WP",
        # Anthracnose, Gummy Stem Blight, Early Blight, Leaf Mold, Septoria Leaf Spot
        "type": "Fungicide",
        "active_ingredients": "Thiophanate-methyl",
        "application_methods": [
            "Mix Thiophanate-methyl with water as per the manufacturer's instructions.",
            "Apply to the plant leaves and stems as a foliar spray.",
            "Repeat applications every 7-14 days depending on disease progression."
        ]
    },
    {
        "name": "Boscalid 50% WG",  # Early Blight, Target Spot, Leaf Mold
        "type": "Fungicide",
        "active_ingredients": "Boscalid",
        "application_methods": [
            "Dilute the product in water as recommended on the label.",
            "Spray directly onto affected leaves and stems to prevent spread of the disease.",
            "Reapply every 10-14 days or as per disease pressure."
        ]
    },
    {
        "name": "Sulfur 80% WP",  # Leaf Mold, Spider mites
        "type": "Fungicide/Acaricide",
        "active_ingredients": "Sulfur",
        "application_methods": [
            "Prepare a dilute solution as per the product's label recommendations.",
            "Apply to the leaves as a preventive measure against fungal infections and mites.",
            "Reapply after heavy rain or as needed during high humidity."
        ]
    },
    {
        "name": "Imidacloprid 17.8% SL",  # Bacterial Wilt, Spider mites
        "type": "Insecticide",
        "active_ingredients": "Imidacloprid",
        "application_methods": [
            "Apply as a soil drench or foliar spray according to label instructions.",
            "For soil application, apply around the base of the plant.",
            "Repeat applications as needed, following label restrictions."
        ]
    },
    {
        "name": "Spiromesifen 22.9% SC",  # Spider mites
        "type": "Acaricide/Insecticide",
        "active_ingredients": "Spiromesifen",
        "application_methods": [
            "Mix with water according to label instructions.",
            "Apply as a foliar spray, ensuring good coverage of both upper and lower leaf surfaces.",
            "Repeat applications as needed, typically 7-14 days apart."
        ]
    }
]

for chemical in chemical_controls:
    ChemicalControl.objects.create(
        name=chemical["name"],
        type=chemical["type"],
        active_ingredients=chemical["active_ingredients"],
        application_methods=chemical["application_methods"]
    )


plant = Plant.objects.get(id=1)
disease = Disease.objects.get(id=5)
plant_disease = PlantDisease(plant=plant, disease=disease)
plant_disease.save()
