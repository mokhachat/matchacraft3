Input = require './input'
Mob = require './mob'
World = require './world'

class Scene
  constructor: (@renderer, @transit)->
    @clock = new THREE.Clock
    @input = new Input document.body
    @scene = new THREE.Scene
    width = window.innerWidth
    height = window.innerHeight
    @camera = new THREE.PerspectiveCamera 72, width / height, 1, 1000
    #@camera = new THREE.OrthographicCamera width / - 2, width / 2, height / 2, height / - 2, 1, 1000 
  
  update: ->
    @renderer.render @scene, @camera

class OrbitScene extends Scene
  constructor: (@renderer, @transit)-> 
    super @renderer, @transit
    #@scene.fog = new THREE.Fog 0xffffff, 100, 1000
    @camera.position.z = -50
    @camera.position.x = 50
    @camera.position.y = 100
    @controls = new THREE.OrbitControls @camera

    @world = new World @scene, 128
    
    #@input.onMouseDown THREE.MOUSE.RIGHT, =>
    #  console.log "transit PLScene"
    #  @transit new PLScene @renderer, @transit


  update: ->
    @world.update @clock.getDelta()
    @controls.update()
    super()
    

class PLScene extends Scene
  constructor: (@renderer, @transit)-> 
    super @renderer, @transit
    @camera.position.z = 100
    @controls = new THREE.PointerLockControls @camera
    @scene.add @controls.getObject()

    geometry = new THREE.BoxGeometry 20, 20, 20
    material = new THREE.MeshBasicMaterial
        color: 0xff0000
        wireframe: true
    @mesh = new THREE.Mesh geometry, material
    @scene.add @mesh

    @input.onMouseDown THREE.MOUSE.LEFT, =>
      console.log "poyo"
      @controls.enabled = true
      unless document.pointerLockElement
        document.body.requestPointerLock()
    
    @input.onDoubleClick =>
      @controls.enabled = false
      if document.pointerLockElement
        document.exitPointerLock()
      console.log "transit OrbitScene"
      @transit new OrbitScene @renderer, @transit
      

module.exports = OrbitScene