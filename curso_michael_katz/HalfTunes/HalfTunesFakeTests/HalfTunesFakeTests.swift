/*
 Enquanto um stub apenas provê respostas prontas para as chamadas que serão feitas durante o teste, o mock  vai mais além e, além de prover as respostas, também valida as chamadas - ele conhece o comportamento esperado do sistema e testa este comportamento.

 Assim, ao substituir um componente durante os testes, um stub teria a seguinte responsabilidade:
 * Se o teste invocar o método A, retorno B.
 * Se o teste invocar o método X, retorno Y.
 * Não tem como função fazer o teste falhar
 
 Enquanto um mock teria a seguinte responsabilidade:
 * O teste deve invocar primeiro o método A, passando o valor 1 como parâmetro, daí retorno B.
 * O teste deve depois invocar o método X, passando o valor 2 como parâmetro, daí retorno Y.
 * Se o teste não seguir exatamente esta sequência, ele falha.
 
 Então podemos colocar na lista de diferenças o fato de que um mock é mais complexo que um stub.
 
 Estabelecido que ambos servem para substituir componentes reais (eles são "dublês" destes componentes) durante os testes, estabelecemos quando usar um e quando usar outro:

 - Use stub para testar se um código, dada uma determinada entrada (respostas prontas dos métodos do stub), produz determinada saída. SUBSTITUI ESTADOS.
 - Use mock para testar se um código se comporta da maneira esperada no que tange a interações com o componente que o mock está substituindo. SUBSTITUI COMPORTAMENTOS.
 */




import XCTest
@testable import HalfTunes

//STUB
//Vamos verificar se o método updateSearchResults() analisa os dados (parses data) que foram baixados corretamente, checando se searchResults.count está correto.
//o SUT é a viewController e vamos simular a sessão com STUB e alguns dados pre-baixados

class HalfTunesFakeTests: XCTestCase {
  
  var sut: SearchViewController!

    override func setUp() {
      super.setUp()
      sut = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? SearchViewController
      
      
      //Esse código configura a fake data and response e cria a falsa sessão. No final ainda adiciona a falsa sessão no app e a configura como uma propriedade do SUT:
      
      let testBundle = Bundle(for: type(of: self))
      let path = testBundle.path(forResource: "abbaData", ofType: "json")
      let data = try? Data(contentsOf: URL(fileURLWithPath: path!),options: .alwaysMapped)
      
      let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
      let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
      
      let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
      sut.defaultSession = sessionMock
      
      
    
      //Esse código testa se chamando o método updateSearchResults() é feita a analise dos dados falsos (parses the fake data). Ainda é necessário escrever o teste como assincrono, pois você está simulando um cenário que é assincrono na realidade:
      
      func test_UpdateSearchResults_ParsesData() {
        // given
        let promise = expectation(description: "Status code: 200")

        // when
        XCTAssertEqual(sut.searchResults.count, 0, "searchResults should be empty before the data task runs")
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let dataTask = sut.defaultSession.dataTask(with: url!) { data, response, error in
          // if HTTP request is successful, call updateSearchResults(_:)
          // which parses the response data into Tracks
          if let error = error {
            print(error.localizedDescription)
          } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            self.sut.updateSearchResults(data)
          }
          promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertEqual(sut.searchResults.count, 3, "Didn't parse 3 items from fake response")
      }
    }

    override func tearDown() {
      sut = nil
      super.tearDown()
        
    }

}
