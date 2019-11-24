
import XCTest
@testable import BullsEye

/* Best Practices for Testing
O acronimo FIRST descreve critério a serem utilizados nos testes unitários:
Fast: Testes devem rodar rapidamente
Independent/Isolated: Testes não devem compartilhar seus estados com outros testes.
Repeatable: Você deve obter o mesmo resultado toda vez que executar um teste. Data providers externos ou problemas de simultaneidade podem causar falhas intermitentes.
Self-validating: Testes devem ser totalmente automatizados. O retorno deve ser simplesmente passou ou falhou, ao invés de depender da iterpretação do programador.
Timely: idealmente, o teste deveria ser escrito antes do código que ele testa(Test-Driven Development).
 */

class BullsEyeTests: XCTestCase {
  
  //Criamos um placeholder para BullsEyeGame, que é o System Under Test (SUT):
  var sut: BullsEyeGame!
  
  //É uma boa prática inicializar o SUT no setUp e desalocar/liberar o SUT no tearDown, para garantir que todo teste comece de um estado "limpo"

    override func setUp() {
      super.setUp()
      sut = BullsEyeGame()
      sut.startNewGame()
    }

    override func tearDown() {
      sut = nil
      super.tearDown()
    }
  
  func testScoreIsComputed() {
    //1.Given: setar os valores que serão utilizados no teste
    let guess = sut.targetValue + 5
    
    //2.When: executar o código que está sendo testado
    sut.check(guess: guess)
    
    //.Then: comparar o resultado obtido com o resultado esperado
    XCTAssertEqual(sut.scoreRound, 95, "Score computed from guess is wrong")
    
  }

}
