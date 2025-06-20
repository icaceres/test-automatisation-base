Feature: Test de API Marvel Characters

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/icaceres/api/characters'
    #ID inicial para pruebas, se debe aumentar segun el secuancia de la base de datos
    * def createdId = 5

  @id:1 @obtenerPersonajes
  Scenario: T-API-SEGCD-0001-Obtener la lista de personajes (puede estar vacía o contener personajes)
    When method get
    Then status 200
    * print response
    * if (karate.sizeOf(response) == 0) karate.log('Lista vacía')
    * if (karate.sizeOf(response) > 0) karate.log('Lista con elementos')


  @id:2 @crearPersonaje
  Scenario: T-API-SEGCD-0002-Crear personaje exitoso
    * def personaje = read('ironman.json')
    Given request personaje
    When method post
    Then status 201
    And match response contains { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
    * def createdId = response.id

  @id:3 @obtenerPersonajePorId
  Scenario: T-API-SEGCD-0003-Obtener personaje por ID (exitoso)
    Given path createdId
    When method get
    Then status 200
    And match response.name == 'Iron Man'

  @id:4 @crearPersonajeConNombreDuplicado
  Scenario: T-API-SEGCD-0004-Crear personaje con nombre duplicado
    * def personajeDuplicado = read('ironman-duplicado.json')
    Given request personajeDuplicado
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

  @id:5 @actualizarPersonaje
  Scenario: T-API-SEGCD-0005-Actualizar el personaje con nuevos datos
    * def updateBody = read('ironman-update.json')
    Given path createdId
    And request updateBody
    When method put
    Then status 200
    And match response.description == 'Genius billionaire Updated'

  @id:6 @eliminarPersonaje
  Scenario: T-API-SEGCD-0006-Eliminar personaje exitosamente
    Given path createdId
    When method delete
    Then status 204

  @id:5 @eliminarPersonajeNoExistente
  Scenario: T-API-SEGCD-0007-Eliminar personaje (no existe)
    Given path 999
    When method delete
    Then status 404
    And match response.error == 'Character not found'
