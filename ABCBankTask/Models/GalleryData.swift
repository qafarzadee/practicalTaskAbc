//  GalleryData.swift
//  Created by Elgun Gafarzada on 20.02.26.

import Foundation

struct PlaceItem {
    let title: String
    let subtitle: String
}

struct GalleryPage {
    let categoryName: String
    let imageName: String
    let items: [PlaceItem]
}

let galleryPages: [GalleryPage] = [
    GalleryPage(categoryName: "Historical Landmarks", imageName: "bahrain_historical", items: [
        PlaceItem(title: "Bahrain Fort", subtitle: "UNESCO World Heritage Site from Dilmun era"),
        PlaceItem(title: "Qal'at al-Bahrain Museum", subtitle: "500 artifacts showcasing ancient history"),
        PlaceItem(title: "Riffa Fort", subtitle: "19th century fort with panoramic views"),
        PlaceItem(title: "Barbar Temple", subtitle: "Ancient Dilmun temple dating to 2000 BC"),
        PlaceItem(title: "Arad Fort", subtitle: "15th century fortress in Muharraq"),
    ]),
    GalleryPage(categoryName: "Mosques & Culture", imageName: "bahrain_culture", items: [
        PlaceItem(title: "Al Fateh Grand Mosque", subtitle: "One of the largest mosques in the world"),
        PlaceItem(title: "Beit Al Quran", subtitle: "Finest collection of ancient Qurans"),
        PlaceItem(title: "Bahrain National Museum", subtitle: "6000 years of history under one roof"),
        PlaceItem(title: "Bahrain National Theatre", subtitle: "Premier performing arts venue"),
    ]),
    GalleryPage(categoryName: "Markets & Shopping", imageName: "bahrain_souq", items: [
        PlaceItem(title: "Manama Souq", subtitle: "Traditional market near Bab Al Bahrain"),
        PlaceItem(title: "Bab Al Bahrain", subtitle: "Iconic gateway to the old marketplace"),
        PlaceItem(title: "Gold Souq", subtitle: "Haggle for gold in the heart of Manama"),
        PlaceItem(title: "Seef Mall", subtitle: "Premier family shopping destination"),
        PlaceItem(title: "Moda Mall", subtitle: "Luxury brands inside the World Trade Center"),
        PlaceItem(title: "The Avenues", subtitle: "Seafront lifestyle and shopping complex"),
    ]),
    GalleryPage(categoryName: "Nature & Leisure", imageName: "bahrain_nature", items: [
        PlaceItem(title: "Tree of Life", subtitle: "400-year-old tree thriving alone in desert"),
        PlaceItem(title: "Al Areen Wildlife Park", subtitle: "Home to over 300 animal species"),
        PlaceItem(title: "Amwaj Islands", subtitle: "Man-made islands with beach resorts"),
        PlaceItem(title: "Hawar Islands", subtitle: "Remote islands perfect for birdwatching"),
        PlaceItem(title: "Dilmun Burial Mounds", subtitle: "UNESCO-listed ancient burial sites"),
    ]),
]
