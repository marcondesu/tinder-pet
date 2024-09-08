import '../model/pet_model.dart';

class PetController {
  List<Pet> pets = [];

  void addPet(Pet pet) {
    pets.add(pet);
  }

  List<Pet> getPets() {
    return pets;
  }
}

/* void marcarEvadido(String nome) {
  for (var aluno in alunos) {
    if (aluno.nome == nome) {
      aluno.isEvadido = true;
    }
  }
} */