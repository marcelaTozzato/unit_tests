//No exemplo deste projeto, estamos utilizando o URLSession para bater na API do iTunes e fazer o download das músicas. Supondo que nós queremos alterar o código para que essa requisição passe a ser feita pelo alamofire. Para verificar se teremos algum problema, devemos escrever testes para o network e roda-los antes e depois da alteração no código.

//Métodos da URLSession são assincronos, ou seja, o retorno/ a continuidade é imediato, mas eles não terminam de rodar até receberem uma resposta. Portanto, para testar métodos assincronos você trabalha com EXPECTATIVA.

//Boa prática: testes assincronos são lentos, portanto devem ficar separados dos testes sincronos



import XCTest
@testable import HalfTunes

class HalfTunesSlowTests: XCTestCase {

  var sut: URLSession!
  
    override func setUp() {
      super.setUp()
      sut = URLSession(configuration: .default)
    }

    override func tearDown() {
      sut = nil
      super.tearDown()
    }

  func testValidCallToiTunesGetsHTTPStatusCode200(){
    //given:
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    //1
    let promise = expectation(description: "Status code: 200")
    
    //when:
    let dataTask = sut.dataTask(with: url!) { (data, response, error) in
      
      //Then:
      if let error = error {
        XCTFail("Error: \(error.localizedDescription)")
        return
      } else if let statusCode = (response as? HTTPURLResponse)?.statusCode{
        if statusCode == 200 {
          //2
          promise.fulfill()
        } else {
          XCTFail("Status code: \(statusCode)")
        }
      }
    }
    dataTask.resume()
    //3
    wait(for: [promise], timeout: 5)
  }
  
  //O teste é similar ao código do app, porém com os seguintes acrescimos:
  //1 - expectation(description): retorna um objeto XCTestExpectation, armazenado em promise. O parametro derscription descreve o que você espera que aconteça
  //2 - promise.fulfill(): é chamado quando o completion handler retorna um sucesso, para informar que a expectativa foi alcançada
  //3 - wait(for: timeout): mantem o teste rodando até que a expectativa seja alcançada ou o tempo se esgote, o que acontecer primeiro

  //No teste acima, ao mudarmos a url retirando o s de iTunes o teste demora 5 segundos para falhar, isto porque dá timeout. Neste teste, estamos assumindo que a requisição sempre será um sucesso e somente neste ponto conseguimos alcançar a expectativa. Porém quando a requisição falha, ficamos dependendo do timeout para interromper o teste.
  
  //Podemos melhorar este teste mudando a suposição: ao invés de esperar que a requisição tenha sucesso, vamos esperar apenas que o complition handler do método assincrono seja invocado (isso ocorre assim que o app receba uma resposta do servidor, seja de ok ou de erro) e depois seu teste pode verificar se a requisiçao obteve sucesso
  
  // A diferença chave é que simplesmente ao entrar no complition handler, a expectativa já é alcançada, e isso leva em torno de 1s (não 5s). Depois disso, se a request falahar, então o código do THEN falha também
  
  func testCallToiTunesCompletes() {
    
    //given
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    let promise = expectation(description: "Complete handler invoked")
    var statusCode: Int?
    var responseError: Error?
    
    //when
    let dataTask = sut.dataTask(with: url!) { (data, response, error) in
      statusCode = (response as? HTTPURLResponse)?.statusCode
      responseError = error
      promise.fulfill()
    }
    dataTask.resume()
    wait(for: [promise], timeout: 5)
    
    //then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }
}
