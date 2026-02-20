//  GalleryData.swift
//  Created by Elgun Gafarzada on 20.02.26.

import Foundation

struct PlaceItem {
    let title: String
    let subtitle: String
    let imageURL: String
}

struct GalleryPage {
    let categoryName: String
    let imageName: String
    let items: [PlaceItem]
}

let galleryPages: [GalleryPage] = [
    GalleryPage(categoryName: "Historical Landmarks", imageName: "bahrain_historical", items: [
        PlaceItem(title: "Bahrain Fort", subtitle: "UNESCO World Heritage Site from Dilmun era",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Bahrain_Fort.jpg/400px-Bahrain_Fort.jpg"),
        PlaceItem(title: "Qal'at al-Bahrain Museum", subtitle: "500 artifacts showcasing ancient history",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Bahrain_Fort_overview.jpg/400px-Bahrain_Fort_overview.jpg"),
        PlaceItem(title: "Riffa Fort", subtitle: "19th century fort with panoramic views",
                  imageURL: "https://upload.wikimedia.org/wikipedia/en/thumb/6/68/Riffa_Fort.jpg/400px-Riffa_Fort.jpg"),
        PlaceItem(title: "Barbar Temple", subtitle: "Ancient Dilmun temple dating to 2000 BC",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Barbar_Temple.jpg/400px-Barbar_Temple.jpg"),
        PlaceItem(title: "Arad Fort", subtitle: "15th century fortress in Muharraq",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Arad_Fort_at_Noon.jpg/400px-Arad_Fort_at_Noon.jpg"),
    ]),
    GalleryPage(categoryName: "Mosques & Culture", imageName: "bahrain_culture", items: [
        PlaceItem(title: "Al Fateh Grand Mosque", subtitle: "One of the largest mosques in the world",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Manama_al-Fateh_Grand_Mosque_Exterior_Norden_3.jpg/400px-Manama_al-Fateh_Grand_Mosque_Exterior_Norden_3.jpg"),
        PlaceItem(title: "Beit Al Quran", subtitle: "Finest collection of ancient Qurans",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Museum-Beit-Al-Quran_%28318%29.jpg/400px-Museum-Beit-Al-Quran_%28318%29.jpg"),
        PlaceItem(title: "Bahrain National Museum", subtitle: "6000 years of history under one roof",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Bahrain_National_Museum_Exterior.jpg/400px-Bahrain_National_Museum_Exterior.jpg"),
        PlaceItem(title: "Bahrain National Theatre", subtitle: "Premier performing arts venue",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Muharraq_Blick_auf_das_National_Theatre_of_Bahrain_1.jpg/400px-Muharraq_Blick_auf_das_National_Theatre_of_Bahrain_1.jpg"),
    ]),
    GalleryPage(categoryName: "Markets & Shopping", imageName: "bahrain_souq", items: [
        PlaceItem(title: "Manama Souq", subtitle: "Traditional market near Bab Al Bahrain",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Manama_Souq.jpg/400px-Manama_Souq.jpg"),
        PlaceItem(title: "Bab Al Bahrain", subtitle: "Iconic gateway to the old marketplace",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Bab_al_Bahrain_alley.jpg/400px-Bab_al_Bahrain_alley.jpg"),
        PlaceItem(title: "Gold Souq", subtitle: "Haggle for gold in the heart of Manama",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Manama_Bab_al-Bahrain_Souq_2.jpg/400px-Manama_Bab_al-Bahrain_Souq_2.jpg"),
        PlaceItem(title: "Seef Mall", subtitle: "Premier family shopping destination",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Seef_Mall%2C_Manama%2C_Bahrain_drawing.JPG/400px-Seef_Mall%2C_Manama%2C_Bahrain_drawing.JPG"),
        PlaceItem(title: "Moda Mall", subtitle: "Luxury brands inside the World Trade Center",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Bahrain_WTC_%2846220337331%29.jpg/400px-Bahrain_WTC_%2846220337331%29.jpg"),
        PlaceItem(title: "The Avenues", subtitle: "Seafront lifestyle and shopping complex",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Avenues_coastline%2C_Bahrain.jpg/400px-Avenues_coastline%2C_Bahrain.jpg"),
    ]),
    GalleryPage(categoryName: "Nature & Leisure", imageName: "bahrain_nature", items: [
        PlaceItem(title: "Tree of Life", subtitle: "400-year-old tree thriving alone in desert",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Tree_of_Life%2C_Bahrain_-_%E0%B4%9C%E0%B5%80%E0%B4%B5%E0%B4%A8%E0%B5%8D%E0%B4%B1%E0%B5%86_%E0%B4%AE%E0%B4%B0%E0%B4%82%2C_%E0%B4%AC%E0%B4%B9%E0%B5%8D%E0%B4%B1%E0%B5%88%E0%B5%BB_01.JPG/400px-Tree_of_Life%2C_Bahrain_-_%E0%B4%9C%E0%B5%80%E0%B4%B5%E0%B4%A8%E0%B5%8D%E0%B4%B1%E0%B5%86_%E0%B4%AE%E0%B4%B0%E0%B4%82%2C_%E0%B4%AC%E0%B4%B9%E0%B5%8D%E0%B4%B1%E0%B5%88%E0%B5%BB_01.JPG"),
        PlaceItem(title: "Al Areen Wildlife Park", subtitle: "Home to over 300 animal species",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Al_Areen_Wildlife_Park_Artificial_Pond.jpg/400px-Al_Areen_Wildlife_Park_Artificial_Pond.jpg"),
        PlaceItem(title: "Amwaj Islands", subtitle: "Man-made islands with beach resorts",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Amwaj_Air.jpg/400px-Amwaj_Air.jpg"),
        PlaceItem(title: "Hawar Islands", subtitle: "Remote islands perfect for birdwatching",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Hawar_Island_aerial_view.jpg/400px-Hawar_Island_aerial_view.jpg"),
        PlaceItem(title: "Dilmun Burial Mounds", subtitle: "UNESCO-listed ancient burial sites",
                  imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/A%27ali_Burial_Mounds.jpg/400px-A%27ali_Burial_Mounds.jpg"),
    ]),
]
