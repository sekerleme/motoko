import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

actor ShelterAnimalManagement {
    // Hayvan veri yapısı
    type Animal = {
        id : Nat;
        name : Text;
        species : Text;
        age : Nat;
        breed : Text;
        isAdopted : Bool;
        healthStatus : Text;
    };

    // Hayvanları saklamak için HashMap
    let animals = HashMap.HashMap<Nat, Animal>(10, Nat.equal, Hash.hash);
    var nextId : Nat = 1;

    // Yeni hayvan ekleme fonksiyonu
    public func addAnimal(
        name : Text, 
        species : Text, 
        age : Nat, 
        breed : Text,
        healthStatus : Text
    ) : async Nat {
        let animalId = nextId;
        let newAnimal : Animal = {
            id = animalId;
            name = name;
            species = species;
            age = age;
            breed = breed;
            isAdopted = false;
            healthStatus = healthStatus;
        };

        animals.put(animalId, newAnimal);
        nextId += 1;
        
        Debug.print("Yeni hayvan eklendi: " # name);
        return animalId;
    };

    // Hayvanı güncelleme fonksiyonu
    public func updateAnimalHealth(id : Nat, newHealthStatus : Text) : async Bool {
        switch (animals.get(id)) {
            case null { false };
            case (?animal) {
                let updatedAnimal : Animal = {
                    id = animal.id;
                    name = animal.name;
                    species = animal.species;
                    age = animal.age;
                    breed = animal.breed;
                    isAdopted = animal.isAdopted;
                    healthStatus = newHealthStatus;
                };
                animals.put(id, updatedAnimal);
                true;
            };
        };
    };

    // Hayvan sahiplendirme fonksiyonu
    public func adoptAnimal(id : Nat) : async Bool {
        switch (animals.get(id)) {
            case null { false };
            case (?animal) {
                if (animal.isAdopted) {
                    false; // Zaten sahiplendirilmiş
                } else {
                    let adoptedAnimal : Animal = {
                        id = animal.id;
                        name = animal.name;
                        species = animal.species;
                        age = animal.age;
                        breed = animal.breed;
                        isAdopted = true;
                        healthStatus = animal.healthStatus;
                    };
                    animals.put(id, adoptedAnimal);
                    Debug.print(animal.name # " isimli hayvan sahiplendirildi.");
                    true;
                };
            };
        };
    };

    // Belirli bir türdeki hayvanları listeleme
    public query func listAnimalsBySpecies(species : Text) : async [Animal] {
        let animalList = animals.vals();
        return Array.filter<Animal>(
            animalList, 
            func(animal) { animal.species == species and not animal.isAdopted }
        );
    };

    // Sahiplendirilebilir hayvanları listeleme
    public query func listAvailableAnimals() : async [Animal] {
        let animalList = animals.vals();
        return Array.filter<Animal>(
            animalList, 
            func(animal) { not animal.isAdopted }
        );
    };
}