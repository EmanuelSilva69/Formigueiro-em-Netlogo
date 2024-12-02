; === INSTRUÇÕES ===
; === DEFINIÇÃO DE VARIÁVEIS ===
globals[current-season seasons]       ;; Estação atual (Primavera, Verão, Outono, Inverno)
breed [worker-ants worker-ant]  ; Formigas Trabalhadoras
breed [soldier-ants soldier-ant] ; Formigas Guerreiras
breed [queen-ants queen-ant] ; Formigas rainha
breed [trees tree] ; Arvore
breed [nests nest]  ; Ninho pras formigas
breed [tamanduas tamandua] ; predador tamandua
breed [pangolims pangolim] ; predador pangolim todo fofinho
breed [lucas luca]; easter egg
breed [wolfs wolf] ; predador dos predadores
; Variáveis dos patches (espaço onde as formigas se movem)
patches-own [
  chemical             ; quantidade de feromônio neste patch
  chemical2             ; quantidade de feromônio neste patch das formigas 2 (nem ferrando que esse é um jeito bom de fazer isso que CRIME jesus)
  chemical3             ; quantidade de feromônio neste patch das formigas 3
  chemical4            ; quantidade de feromônio neste patch das formigas 4
  food                 ; quantidade de comida neste patch (0, 1 ou 2)
  nest?                ; verdadeiro se o patch é parte do ninho, falso caso contrário
  nest2?               ; verdadeiro se o patch é parte do ninho, falso caso contrário
  nest3?               ; verdadeiro se o patch é parte do ninho, falso caso contrário
  nest4?                ; verdadeiro se o patch é parte do ninho, falso caso contrário
  nest-scent           ; valor numérico maior próximo ao ninho, usado para orientar as formigas
  nest-scent2           ; valor numérico maior próximo ao ninho, usado para orientar as formigas 2
  nest-scent3           ; valor numérico maior próximo ao ninho, usado para orientar as formigas 3
  nest-scent4           ; valor numérico maior próximo ao ninho, usado para orientar as formigas 4
  food-source-number   ; identifica as fontes de alimento (1, 2 ou 3)
  food-store ; guardar comida no ninho
  food-store2 ; guardar comida no ninho
  food-store3 ; guardar comida no ninho
  food-store4 ; guardar comida no ninho
  obstáculo?; patch obstáculo
  obstáculo2?; patch obstáculo

]
; Forma da Formiga ter energia e morrer, além dos atributos que eu criei
worker-ants-own [energy colony life strenght mutation speed  vitima]
soldier-ants-own [energy colony life strenght mutation speed role vitima]
queen-ants-own [energy colony life strenght mutation speed vitima]
trees-own [energy]
pangolims-own [energy colony life strenght speed]
tamanduas-own [energy colony life strenght speed]
lucas-own [life strenght speed]
wolfs-own [energy colony life strenght speed]

; === PROCEDIMENTOS DE CONFIGURAÇÃO ===
to setup
  clear-all                            ; limpa o mundo e reinicia a simulação
  reset-ticks
  set-default-shape worker-ants "bug"       ; define o formato das formigas como "inseto"
   set-default-shape soldier-ants "bug"       ; define o formato das formigas como "inseto"
   set-default-shape queen-ants "ant 2"       ; define o formato das formigas como "inseto"
   set seasons ["Primavera" "Verão" "Outono" "Inverno"]
  set current-season one-of seasons
  print (word "A estação inicial é:  " current-season)
  let colony-colors [violet blue 126 yellow] ; Cada ninho tem uma cor única
    foreach colony-colors [colony-color ->
  create-worker-ants population [           ; cria formigas com base no valor do slider 'population'
    set vitima false
    set size 1.5                          ; tamanho base
    set color colony-color                       ; vermelho indica que não está carregando comida
    set energy 1000                       ; da a energia da formiga
    set colony colony-color ; atribui a colônia
    aplicar-atributos
  ]
    create-soldier-ants popsold [ ;população de soldados
    set vitima false
    set size 2.5                          ; aumenta o tamanho para melhor visualização
    set color colony-color + 3                      ; formiga soldado é magenta (tirei a cor do site lá) um pouco diferente do trabalhador
    set energy 1000                       ; da a energia da formiga
    set colony colony-color ; atribui a colônia
    set role "Patrulha"
    aplicar-atributos
  ]
    create-trees 2 [
    set shape "tree"
    set size 15
    move-to one-of patches with [not any? turtles-here]
    set color green
    set energy 1000000000000000

  ]
    create-queen-ants 1 [
    set vitima false
    set size 4                         ; aumenta o tamanho para melhor visualização
    set color (colony-color - 2)                       ; formiga soldado é magenta (tirei a cor do site lá)
    set energy 1000000                  ; da a energia da formiga
    set colony colony-color ; atribui a colônia
    aplicar-atributos
  ]
  ]
  setup-patches                         ; chama o procedimento para configurar os patches
  setup-food
  ;setup-nest para nest turtle
  mover-formiga
  setup-obstaculos
  reset-ticks                           ; reinicia o contador de tempo da simulação
end

to setup-patches
  ask patches [
  set obstáculo? false
    setup-nest                          ; configura o ninho nos patches
    ;setup-food                          ; configura as fontes de alimento
    recolor-patch                       ; define as cores dos patches para visualização


  ]
end
to mover-formiga ;comando pra movimentar as formigas
  ask worker-ants [
  move-to one-of patches with [pcolor = [colony] of myself]
]

ask soldier-ants [
  move-to one-of patches with [pcolor = [colony] of myself]
]

ask queen-ants [
  move-to one-of patches with [pcolor = [colony] of myself]
]
end
to aplicar-atributos ;[violet blue 126 yellow] [energy life strenght speed] botei força pra ser um pouco mais genérico, talvez deva botar "picada?" , mutação é a taxa randomica.
  if colony = violet [
    set energy  1000
    set life  15
    set strenght  3
    set speed 1
    if breed = soldier-ants[
    set life  45
    set strenght  5
    ]
    if breed = queen-ants[
    set life  200
    set strenght  20
  ]]
   if colony = blue [
    set energy  1300
    set life  7
    set strenght  1
    set speed 1.5
    if breed = soldier-ants[
    set life  16
    set strenght  3
    ]
    if breed = queen-ants[
    set life  140
    set strenght  15
  ]]
   if colony = 126 [
    set energy  800
    set life  30
    set strenght  5
    set speed 0.5
    if breed = soldier-ants[
    set life  62
    set strenght  8
    ]
    if breed = queen-ants[
    set life  300
    set strenght  25
  ]]
   if colony = yellow [
    set energy  925
    set life  17
    set strenght  4
    set speed 0.75
    if breed = soldier-ants[
    set life  52
    set strenght  7.5
    ]
    if breed = queen-ants[
    set life  260
    set strenght  23
    ]
]
  ifelse random-float 1 < 0.3 [ ;botei 30% de chance para ver um impacto real, talvez diminua dps.
    ; Aplica mutação
    set mutation "yes"
    set life life * (1 + random-float 1.0 - 1.0) ; aumenta a vida em 100% // ou diminui
    set strenght strenght * (1 + random-float 2.0 - 2.0) ; Aumenta a força até 200% // ou diminui
    set speed speed * (1 + random-float 0.5 - 0.5)       ; Aumenta a velocidade até 50% // ou diminui
  ] [
    set mutation "no"
  ]
end
to setup-nest  ;; patch procedure
    set nest? false
    set food-store 0
  set food-store2 0 ;começa com 0 comidas guardadas
  set food-store3 0
  set food-store4 0
    set nest2? false
    set nest3? false ;Sem isso daqui dá um erro tenebroso n sei pq
    set nest4? false
  ;; set nest? variable to true inside the nest, false elsewhere
  set nest? (distancexy -16 -36) < 5
  set nest2? (distancexy 40 -32) < 5
  set nest3? (distancexy -30 36) < 5
  set nest4? (distancexy 26 47) < 5
  ;; spread a nest-scent over the whole world -- stronger near the nest
  set nest-scent 400 - distancexy -16 -36
   set nest-scent2 400 - distancexy 40 -32
   set nest-scent3 400 - distancexy -30 36
   set nest-scent4 400 - distancexy 26 47
end

to setup-food  ; procedimento dos patches Isso daqui gera em posições específicas, coisa que eu não quero. Melhor começar do 0
   ask patches [
    set food 0
    set food-source-number 0
  ]
  ask turtles with [shape = "tree"] [
    ; Para cada árvore, define patches ao redor como fontes de alimento
    let nearby-patches patches in-radius 9 ; Ajuste o raio conforme necessário
    ask nearby-patches [
      if random 100 < chancedomida [ ; 50% de chance de gerar comida em cada patch ao redor
        set food one-of [1 2] ; Define quantidade de comida aleatória (1 ou 2)
        set food-source-number [who] of myself ; Identifica a árvore como fonte de alimento
        if food = 1 [ set pcolor red ] ; Comida 1 -> vermelho
        if food = 2 [ set pcolor orange ]   ; Comida 2 -> laranja
        if food = 1[ set food-source-number 1]
        if food = 2[ set food-source-number 2]
      ]
    ]
  ]

  ;Configura três fontes de alimento em posições específicas
  ;if (distancexy (0.6 * max-pxcor) 0) < 5 [
    ;set food-source-number 1
 ; ]
  ;if (distancexy (-0.6 * max-pxcor) (-0.6 * max-pycor)) < 5 [
   ; set food-source-number 2
; ]
  ;if (distancexy (-0.8 * max-pxcor) (0.8 * max-pycor)) < 5 [
   ; set food-source-number 3
 ; ]
  ; Se o patch faz parte de uma fonte de alimento, atribui uma quantidade de comida (1 ou 2)
  ;if food-source-number > 0 [
   ; set food one-of [1 2]
  ;]
end


to recolor-patch  ; procedimento dos patches
  ifelse nest? [
    set pcolor violet                   ; patches do ninho em violeta
  ] [
    ifelse food > 0 [
      ; patches com comida são coloridos de acordo com a fonte
      if food-source-number = 1 [ set pcolor red ]
      if food-source-number = 2 [ set pcolor orange ]
      ;if food-source-number = 3 [ set pcolor blue ]
    ] [
      ; patches normais variam de cor com base na quantidade de feromônio
      let max-chemical max (list chemical chemical2 chemical3 chemical4)
      if max-chemical > 0.01 [  ; só recolore patches com feromônio

       if max-chemical = chemical [ set pcolor scale-color 117 chemical -11 60] ;violeta claro (decidi deixar os feromonios relacionados com as cores pra n ficar um inferno na tela)
      if max-chemical = chemical2 [ set pcolor scale-color cyan chemical2 -11 60 ] ;variação de azul
      if max-chemical = chemical3 [ set pcolor scale-color 137 chemical3 -11 60 ] ;magenta é daqui pra lá pra rosa.
      if max-chemical = chemical4 [ set pcolor scale-color 48 chemical4 -11 60 ] ; amarelo n tem pra onde fugir n, netlogo n tem muitas cores de amarelo .-.
      ]
      if obstáculo? = false [
      if max-chemical < 0.01 [
      ;; Reset to the base color of the current season
      if current-season = "Primavera" [ set pcolor 63 ]
      if current-season = "Verão" [ set pcolor 43 ]
      if current-season = "Outono" [ set pcolor 23 ]
      if current-season = "Inverno" [ set pcolor white ]
      ]]

      if obstáculo? = true [set pcolor gray]
  ]]
    if nest2? [
    set pcolor blue                  ; patches do ninho em  azul (ninho 2)
  ]
    if nest3? [
    set pcolor 126                   ; patches do ninho em magenta claro ninho 3
  ]
   if nest4? [
    set pcolor yellow                   ; patches do ninho em amarelo ninho 4
  ]



end

; === PROCEDIMENTOS PRINCIPAIS ===

to go
  ask worker-ants [
    if colony = blue[
     if ticks < (ticks - ticks mod 4) and ticks mod 4 != 2 [stop]     ; sincroniza a saída das formigas do ninho com o tempo para qur todas saiam juntas
     ifelse color = blue ; erro resolvido.
        [look-for-food2 ] [ return-to-nest2 ]] ; diz pra procurar comida ou voltar pro ninho.
    if colony = violet[
      if ticks < (ticks - ticks mod 4) and ticks mod 4 != 2 [stop]       ; sincroniza a saída das formigas do ninho com o tempo para qur todas saiam juntas
        ifelse color = violet [look-for-food ] [ return-to-nest ]]
    if colony = 126[
      if ticks < (ticks - ticks mod 4) and ticks mod 4 != 2 [stop]
       ifelse color = 126 ;cor da formiga normal
        [look-for-food3 ] [ return-to-nest3 ]]
    if colony = yellow[
       if ticks < (ticks - ticks mod 4) and ticks mod 4 != 2 [stop]
       ifelse color = yellow
        [look-for-food4 ] [ return-to-nest4 ]]

    wiggle                               ; movimento aleatório para simular procura
    move-forward speed                                 ; move-se para frente
    set energy energy - 1                ; Diminui a energia delas
  ]
  ask soldier-ants [
    if colony = violet[
    if ticks < (ticks - ticks mod 4) and ticks mod 4 != 2 [stop]
    if color = violet + 3
     [ patrulha-ou-luta
        movimento-soldado]
     set energy energy - 1
    ]
    if colony = blue[
    if ticks < (ticks - ticks mod 4) and ticks mod 4 != 2 [stop]
     if color = blue + 3[
     patrulha-ou-luta
        movimento-soldado2]
        set energy energy - 1
    ]
    if colony = 126[
    if ticks < (ticks - ticks mod 4) and ticks mod 4 != 2 [stop]
     if color = 126 + 3[
     patrulha-ou-luta
        movimento-soldado3]
     set energy energy - 1
    ]
    if colony = yellow[
    if ticks < (ticks - ticks mod 4) and ticks mod 4 != 2 [stop]
 if color = yellow + 3[
      patrulha-ou-luta
        movimento-soldado4]
     set energy energy - 1
    ]
  ]
  ask queen-ants [
  ;tamanhoseason tamamho de cada season
 if (ticks mod tamanhoseason = 0)[
    if colony = violet[
      if color = violet - 2 [
      let total-food sum [food-store] of patches
      if total-food > Preçoconstrução [ ; preço para subtrair da comida para gerar formiga
      nascimento
      set food-store food-store - Preçoconstrução
    ]]]
    if colony = blue[
      if color = blue - 2 [
      let total-food2 sum [food-store2] of patches
      if total-food2 > Preçoconstrução [
      nascimento
      set food-store2 food-store2 - Preçoconstrução
    ]]]
    if colony = 126[

      if color = 126 - 2 [
      let total-food3 sum [food-store3] of patches
      if total-food3 > Preçoconstrução [
      nascimento
      set food-store3 food-store3 - Preçoconstrução
    ]]
       ]
    if colony = yellow[
      if color = yellow - 2 [
       let total-food4 sum [food-store4] of patches
      if total-food4 > Preçoconstrução [
      nascimento
      set food-store4 food-store4 - Preçoconstrução
  ]]]
   ]]




 diffuse chemical (diffusion-rate / 100) ;difusão dos feromonios
  diffuse chemical2 (diffusion-rate / 100)
  diffuse chemical3 (diffusion-rate / 100)
  diffuse chemical4 (diffusion-rate / 100)
  ask patches [
    set chemical chemical * (100 - evaporation-rate) / 100
    set chemical2 chemical2 * (100 - evaporation-rate) / 100  ; evaporação dos feromonios
    set chemical3 chemical3 * (100 - evaporation-rate) / 100
    set chemical4 chemical4 * (100 - evaporation-rate) / 100
    recolor-patch ; atualiza as cores após mudança
  ]
  ask wolfs[ wiggle
    fd speed
  ]

  ask tamanduas[
    wiggle
    fd speed
  ]
  ask pangolims[
        wiggle
    fd speed
  ]
  handle-season-change
  kill-nestvazia
  predar
  ask lucas[
     wiggle                               ; movimento aleatório para simular procura
    move-forward speed                                 ; move-se para frente
    easter-egglucas] ; cometer assassinato
  check-death
  tick                                  ; avança o contador de tempo da simulação

end



; === COMPORTAMENTOS DAS FORMIGAS ===

to look-for-food  ; procedimento das formigas
  if food > 0
  [ set color violet + 1     ;; pick up food
    set food food - 1        ;; and reduce the food source
    rt 180                   ;; and turn around
    stop ]
    ;; go in the direction where the chemical smell is strongest
  if (chemical >= 0.05) and (chemical < 2)
  [ uphill-chemical ]
end
to look-for-food2  ; procedimento das formigas
      if food > 0
  [ set color sky + 1    ;; pick up food
    set food food - 1        ;; and reduce the food source
    rt 180                   ;; and turn around
    stop ]
    ;; go in the direction where the chemical smell is strongest
  if (chemical2 >= 0.05) and (chemical2 < 2)
  [ uphill-chemical2 ]
end
to look-for-food3  ; procedimento das formigas
if food > 0[
  set color 136 + 1
  set food food - 1        ;; and reduce the food source
    rt 180                   ;; and turn around
    stop ]
    ;; go in the direction where the chemical smell is strongest
  if (chemical3 >= 0.05) and (chemical3 < 2)
  [ uphill-chemical3 ]
end
to look-for-food4 ; procedimento das formigas
if food > 0[
  set color yellow + 2
  set food food - 1        ;; and reduce the food source
    rt 180                   ;; and turn around
    stop ]
    ;; go in the direction where the chemical smell is strongest
  if (chemical4 >= 0.05) and (chemical4 < 2)
  [ uphill-chemical4 ]
end

to return-to-nest
    ifelse nest? [
      set color violet                  ; Deposita comida e volta à cor original
    set food-store food-store + 1
      rt 180
    ] [
      set chemical chemical + 60        ; Libera feromônio no caminho
      uphill-nest-scent                 ; Move-se na direção do ninho
    ]

end
to return-to-nest2
    ifelse nest2? [
      set color blue                    ; Deposita comida e volta à cor original
    set food-store2 food-store2 + 1
      rt 180
    ] [
      set chemical2 chemical2 + 60      ; Libera feromônio no caminho
      uphill-nest-scent2                ; Move-se na direção do ninho
    ]

end
to return-to-nest3
    ifelse nest3? [
      set color 126                     ; Deposita comida e volta à cor original
      set food-store3 food-store3 + 1
      rt 180
    ] [
      set chemical3 chemical3 + 60      ; Libera feromônio no caminho
      uphill-nest-scent3                ; Move-se na direção do ninho
    ]

end
to return-to-nest4

    ifelse nest4? [
      set color yellow                  ; Deposita comida e volta à cor original
      set food-store4 food-store4 + 1
      rt 180
    ] [
      set chemical4 chemical4 + 60      ; Libera feromônio no caminho
      uphill-nest-scent4                ; Move-se na direção do ninho
    ]

end


to check-death ;ver se a formiga vai morrer
  ask worker-ants [
    if energy <= 0 or life <= 0 [ die ]
  ]
    ask soldier-ants [
    if energy <= 0 or life <= 0 [ die ]
  ]
  ask queen-ants [
    if energy <= 0 or life <= 0 [ die ]
  ]
  ask tamanduas[
   if energy <= 0 or life <= 0 [ die ]
  ]
   ask pangolims[
  if energy <= 0 or life <= 0 [ die ]
    ]
end
to patrulha-ou-luta
  let inimigos-proximos turtles with [(breed != trees) and (breed = worker-ants or breed = soldier-ants or breed = queen-ants or breed = pangolims or breed = tamanduas) and
    (colony != [colony] of myself) and  (distance myself < 10)]
  ifelse any?  inimigos-proximos ;;pra impedir as formigas de atacarem as arvores
     [
    set role "fighting"      ;; Muda o trabalho para Modo Lutador, pra meter a porrada nos trabalhadores inocentes (que nem a vida real)
    let inimigo-atual one-of inimigos-proximos
    face inimigo-atual  ;; Vira-se para o inimigo
    fd 1                ;; Move-se 1 passo em direção ao inimigo
    ask inimigo-atual[
      face self
      set life life - [strenght] of myself
  ]]
     [
    set role "patrolling"    ;; Caso n veja nenhum inimigo, continuar patrulhando o ninho original.
  ]

end
to easter-egglucas
 if breed = lucas[
  let inimigos-proximos turtles with [(breed != trees) and (breed != lucas) and (distance myself < 10) ]
  if any?  inimigos-proximos ;;pra impedir as formigas de atacarem as arvores
     [
    let inimigo-atual one-of inimigos-proximos
    face inimigo-atual  ;; Vira-se para o inimigo
    fd 1                ;; Move-se 1 passo em direção ao inimigo
    ask inimigo-atual[
      face self
      set life life - [strenght] of myself
  ]]]
end



to kill-nestvazia ;acabar com as nests vazias.
   ;; Verifica os ninhos e suas respectivas rainhas
  ask patches with [nest? or nest2? or nest3? or nest4?] [
    if nest? [
      if not any? turtles with [breed = queen-ants and colony = violet] [
        ;; Remove o ninho se não houver rainha correspondente
        set nest? false
        set nest-scent 0
        set food-store 0
      if current-season = "Primavera" [ set pcolor 63 ]
      if current-season = "Verão" [ set pcolor 43 ]
      if current-season = "Outono" [ set pcolor 23 ]
      if current-season = "Inverno" [ set pcolor white ]
      ]
    ]
    if nest2? [
      if not any? turtles with [breed = queen-ants and colony = blue] [
        ;; Remove o ninho se não houver rainha correspondente
        set nest2? false
        set nest-scent2 0
        set food-store2 0
         if current-season = "Primavera" [ set pcolor 63 ]
      if current-season = "Verão" [ set pcolor 43 ]
      if current-season = "Outono" [ set pcolor 23 ]
      if current-season = "Inverno" [ set pcolor white ]
      ]
    ]
    if nest3? [
      if not any? turtles with [breed = queen-ants and colony = 126] [
        ;; Remove o ninho se não houver rainha correspondente
        set nest3? false
        set nest-scent3 0
        set food-store3 0
         if current-season = "Primavera" [ set pcolor 63 ]
      if current-season = "Verão" [ set pcolor 43 ]
      if current-season = "Outono" [ set pcolor 23 ]
      if current-season = "Inverno" [ set pcolor white ]
      ]
    ]
    if nest4? [
      if not any? turtles with [breed = queen-ants and colony = yellow] [
        ;; Remove o ninho se não houver rainha correspondente
        set nest4? false
        set nest-scent4 0
        set food-store4 0
         if current-season = "Primavera" [ set pcolor 63 ]
      if current-season = "Verão" [ set pcolor 43 ]
      if current-season = "Outono" [ set pcolor 23 ]
      if current-season = "Inverno" [ set pcolor white ]
      ]
    ]
  ]

end
to nascimento
 if colony = violet[
      let num-new-ants nascimentoformiga + random 10  ;; slide do nascimento de formiga + incremento de 0 a 10  aleatório ->
     hatch-worker-ants num-new-ants [
      setxy -16 -36  ;; Spawnar perto da rainha violeta
      set shape "bug"
      set color violet
      set energy 100
      set size 1.5
      set colony violet
     ; mover-formiga ;; Spawnar perto da rainha violeta
      aplicar-atributos
      ]
    hatch-soldier-ants random 5 [
      setxy -18 -38  ;; Spawnar perto da rainha violeta
      set shape "bug"
      set color violet + 3
      set energy 100
      set size 2.5
      set colony violet
      aplicar-atributos
    ]
  ]

 if colony = blue[
    ask queen-ants[
      let num-new-ants random 9 + 1  ;; fazer nascer de 1 a 9
     hatch-worker-ants num-new-ants [
       setxy 40 -32  ;; Spawnar perto da rainha azul (
      set shape "bug"
      set color blue
      set energy 100
      set size 1.5
      set colony blue
    ;  mover-formiga ;; Spawnar perto da rainha azul -> trava em todo spawn por meio segundo, fica ruim logo n vou utilizar, já que o spawn especifico é mais leve no programa.
      aplicar-atributos
      ]
       hatch-soldier-ants random 5 [ ;aleatório pra n ficar quebrado.
      setxy 39 -34  ;; Spawnar perto da rainha violeta
      set shape "bug"
      set color blue + 3
      set energy 1000
      set size 2.5
      set colony blue
      aplicar-atributos
    ]
]]

  if colony = 126[
    ask queen-ants[

      let num-new-ants random 9 + 1  ;; fazer nascer de 1 a 9
     hatch-worker-ants num-new-ants [
       setxy -30 36  ;; Spawnar perto da rainha magenta
      set shape "bug"
      set color 126
      set energy 100
      set size 1.5
          set colony 126
        ;mover-formiga ;; Spawnar perto da rainha magenta
      aplicar-atributos
    ]  hatch-soldier-ants random 5 [
      setxy -28 35  ;; Spawnar perto da rainha violeta
      set shape "bug"
      set color 126 + 3
      set energy 1000
      set size 2.5
      set colony 126
      aplicar-atributos
    ]
    ]
  ]


  if colony = yellow[
    ask queen-ants[

      let num-new-ants random 9 + 1  ;; fazer nascer de 1 a 9
     hatch-worker-ants num-new-ants [
           setxy 26 47  ;; Spawnar perto da rainha amarela
      set shape "bug"
      set color yellow
      set energy 100
      set size 1.5
      set colony yellow
      aplicar-atributos
  ]
       hatch-soldier-ants random 5 [
      setxy 30 40  ;; Spawnar perto da rainha violeta
      set shape "bug"
      set color yellow + 3
      set energy 1000
      set size 2.5
      set colony yellow
      aplicar-atributos
    ]
  ]]


end
; === MOVIMENTAÇÃO E ORIENTAÇÃO === ME perdoe por esse crime que vocês vão ver

to uphill-chemical  ; procedimento das formigas
  let scent-ahead chemical-scent-at-angle 0
  let scent-right chemical-scent-at-angle 45
  let scent-left chemical-scent-at-angle -45
  if (scent-ahead > 0) or (scent-right > 0) or (scent-left > 0) [
  ifelse (scent-right > scent-ahead) or (scent-left > scent-ahead) [
    ifelse scent-right > scent-left [
      rt random 30 + 30 ; Ajusta ângulo para seguir o gradiente à direita
    ] [
      lt random 30 + 30 ; Ajusta ângulo para seguir o gradiente à esquerda
    ]
  ]
  [
    wiggle  ; Movimento randômico se não houver feromônio detectado
    move-forward 1
  ]
  ]
end

to uphill-chemical2  ; procedimento das formigas
  let scent-ahead chemical-scent-at-angle2 0
  let scent-right chemical-scent-at-angle2 45
  let scent-left chemical-scent-at-angle2 -45
   if (scent-ahead > 0) or (scent-right > 0) or (scent-left > 0) [
  ifelse (scent-right > scent-ahead) or (scent-left > scent-ahead) [
    ifelse scent-right > scent-left [
      rt random 30 + 30 ; Ajusta ângulo para seguir o gradiente à direita
    ] [
      lt random 30 + 30 ; Ajusta ângulo para seguir o gradiente à esquerda
    ]
  ]
  [
    wiggle  ; Movimento randômico se não houver feromônio detectado
    move-forward 1
  ]
  ]
end

to uphill-chemical3  ; procedimento das formigas
  let scent-ahead chemical-scent-at-angle3 0
  let scent-right chemical-scent-at-angle3 45
  let scent-left chemical-scent-at-angle3 -45

  if(scent-right > scent-ahead) or (scent-left > scent-ahead) [
    ifelse scent-right > scent-left [
      rt random 30 + 30 ; Ajusta ângulo para seguir o gradiente à direita
    ] [
      lt random 30 + 30 ; Ajusta ângulo para seguir o gradiente à esquerda
    ]
  ]

end

to uphill-chemical4  ; procedimento das formigas
  let scent-ahead chemical-scent-at-angle4 0
  let scent-right chemical-scent-at-angle4 45
  let scent-left chemical-scent-at-angle4 -45

  if (scent-right > scent-ahead) or (scent-left > scent-ahead) [
    ifelse scent-right > scent-left [
      rt random 30 + 30 ; Ajusta ângulo para seguir o gradiente à direita
    ] [
      lt random 30 + 30 ; Ajusta ângulo para seguir o gradiente à esquerda
    ]

  ]
end

to uphill-nest-scent  ;; turtle procedure
  let scent-ahead nest-scent-at-angle   0
  let scent-right nest-scent-at-angle  45
  let scent-left  nest-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 45 ]
    [ lt 45 ] ]
   let obstaculo one-of patches in-radius 1 with [obstáculo?]
  if obstaculo = true [ rt 180 ]
end
to uphill-nest-scent2  ; procedimento das formigas
  let scent-ahead nest-scent-at-angle2 0
  let scent-right nest-scent-at-angle2 45
  let scent-left nest-scent-at-angle2 -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead) [
    ifelse scent-right > scent-left [
      rt 45                              ; vira 45 graus à direita
    ] [
      lt 45                              ; vira 45 graus à esquerda
    ]
  ]
   let obstaculo one-of patches in-radius 1 with [obstáculo?]
  if obstaculo = true [ rt 180 ]
end
to uphill-nest-scent3  ; procedimento das formigas
  let scent-ahead nest-scent-at-angle3 0
  let scent-right nest-scent-at-angle3 45
  let scent-left nest-scent-at-angle3 -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead) [
    ifelse scent-right > scent-left [
      rt 45                              ; vira 45 graus à direita
    ] [
      lt 45                              ; vira 45 graus à esquerda
    ]
  ]
   let obstaculo one-of patches in-radius 1 with [obstáculo?]
  if obstaculo = true [ rt 180 ]
end
to uphill-nest-scent4  ; procedimento das formigas
  let scent-ahead nest-scent-at-angle4 0
  let scent-right nest-scent-at-angle4 45
  let scent-left nest-scent-at-angle4 -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead) [
    ifelse scent-right > scent-left [
      rt 45                              ; vira 45 graus à direita
    ] [
      lt 45                              ; vira 45 graus à esquerda
    ]
  ]
   let obstaculo one-of patches in-radius 1 with [obstáculo?]
  if obstaculo = true [ rt 180 ]
end

to wiggle  ; procedimento das formigas  MODIFICADO PARA EVITAR OBSTACULO

  rt random 45                           ; vira um ângulo aleatório à direita
  lt random 45                           ; vira um ângulo aleatório à esquerda
  if not can-move? 1 [ rt 180 ]          ; se não puder se mover, vira 180 graus
  let obstaculo one-of patches in-radius 1 with [obstáculo?]
  if obstaculo = true [ rt 180 ]
end

to movimento-soldado
  if role = "patrolling"[
  let closest-nest one-of patches with [
    nest? = true and pcolor = violet
  ]  let nest-x -16  ;; Define the x-coordinate of the nest
  let nest-y -36  ;; Define the y-coordinate of the nest

  ;; Move in a circular pattern by adjusting the heading randomly and moving forward
  set heading heading + random 10 ;; Randomize the heading a bit for a more natural movement
  move-forward speed ;; Move forward

  ;; If the soldier ant is too close to the nest, change direction (patrol behavior)
  ifelse distancexy nest-x nest-y < 3 [
    rt random 90  ;; Turn randomly to avoid staying at the same spot
    move-forward speed        ;; Move forward
  ][
    ;; Continue patrolling around the defined spot
    rt 15  ;; Rotate by a small amount to keep patrolling in a circle
    move-forward speed    ;; Move forward
  ]]


end
to movimento-soldado2
    if role = "patrolling"[
 let closest-nest one-of patches with [
    nest? = true and pcolor = blue
  ]
  ;; Define a specific spot where the soldier ant will patrol (e.g., the nest location)
  let nest-x -16  ;; Define the x-coordinate of the nest
  let nest-y -36  ;; Define the y-coordinate of the nest


  ;; Move in a circular pattern by adjusting the heading randomly and moving forward
  set heading heading + random 10 ;; Randomize the heading a bit for a more natural movement
  move-forward speed  ;; Move forward

  ;; If the soldier ant is too close to the nest, change direction (patrol behavior)
  ifelse distancexy nest-x nest-y < 3 [
    rt random 90  ;; Turn randomly to avoid staying at the same spot
    move-forward speed         ;; Move forward
  ][
    ;; Continue patrolling around the defined spot
    rt 15  ;; Rotate by a small amount to keep patrolling in a circle
    move-forward speed    ;; Move forward
  ]]
end
to movimento-soldado3
    if role = "patrolling"[
  let closest-nest one-of patches with [
    nest? = true and pcolor = 126
  ]
  ;; Define a specific spot where the soldier ant will patrol (e.g., the nest location)
  let nest-x -16  ;; Define the x-coordinate of the nest
  let nest-y -36  ;; Define the y-coordinate of the nest


  ;; Move in a circular pattern by adjusting the heading randomly and moving forward
  set heading heading + random 10 ;; Randomize the heading a bit for a more natural movement
  move-forward speed  ;; Move forward

  ;; If the soldier ant is too close to the nest, change direction (patrol behavior)
  ifelse distancexy nest-x nest-y < 3 [
    rt random 90  ;; Turn randomly to avoid staying at the same spot
    move-forward speed         ;; Move forward
  ][
    ;; Continue patrolling around the defined spot
    rt 15  ;; Rotate by a small amount to keep patrolling in a circle
    move-forward speed    ;; Move forward
  ]]
end
to movimento-soldado4
    if role = "patrolling"[
 let closest-nest one-of patches with [
    nest? = true and pcolor = yellow
  ]
  ;; Define a specific spot where the soldier ant will patrol (e.g., the nest location)
  let nest-x -16  ;; Define the x-coordinate of the nest
  let nest-y -36  ;; Define the y-coordinate of the nest


  ;; Move in a circular pattern by adjusting the heading randomly and moving forward
  set heading heading + random 10 ;; Randomize the heading a bit for a more natural movement
  move-forward speed  ;; Move forward

  ;; If the soldier ant is too close to the nest, change direction (patrol behavior)
  ifelse distancexy nest-x nest-y < 3 [
    rt random 90  ;; Turn randomly to avoid staying at the same spot
    move-forward speed        ;; Move forward
  ][
    ;; Continue patrolling around the defined spot
    rt 15  ;; Rotate by a small amount to keep patrolling in a circle
    move-forward speed   ;; Move forward
  ]]
  if role = "fighting"[

  ]
end

; === FUNÇÕES AUXILIARES ===

to-report nest-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]             ; se não houver patch, retorna 0
  report [nest-scent] of p               ; retorna o valor de 'nest-scent' do patch
end
to-report nest-scent-at-angle2 [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]             ; se não houver patch, retorna 0
  report [nest-scent2] of p               ; retorna o valor de 'nest-scent' do patch
end
to-report nest-scent-at-angle3 [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]             ; se não houver patch, retorna 0
  report  [nest-scent3] of p              ; retorna o valor de 'nest-scent' do patch
end
to-report nest-scent-at-angle4 [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]             ; se não houver patch, retorna 0
  report [nest-scent4] of p                ; retorna o valor de 'nest-scent' do patch
end
to-report chemical-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]             ; se não houver patch, retorna 0
  report [chemical] of p                 ; retorna o valor de 'chemical' do patch
end
to-report chemical-scent-at-angle2 [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]             ; se não houver patch, retorna 0
  report [chemical2] of p                  ; retorna o valor de 'chemical' do patch
end
to-report chemical-scent-at-angle3 [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]             ; se não houver patch, retorna 0
  report [chemical3] of p                  ; retorna o valor de 'chemical' do patch
end
to-report chemical-scent-at-angle4 [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]             ; se não houver patch, retorna 0
  report [chemical4] of p                 ; retorna o valor de 'chemical' do patch
end
;=== Funções de alteração do clima ===
to handle-season-change
  if (ticks mod tamanhoseason = 0) [ ; variável que permite a mudança climática
    ;; Atualiza a estação
     let current-index position current-season seasons
     let next-index (current-index + 1) mod length seasons ;pega a próxima estação da lista lá de cima  set seasons ["Primavera" "Verão" "Outono" "Inverno"]
    set current-season item next-index seasons ; Vai pra próxima estação
    ;if current-season = "Primavera" [ set current-season "Verão" ]
   ;  if current-season = "Verão" [ set current-season "Outono" ]
    ; if current-season = "Outono" [ set current-season "Inverno" ]
    ; if current-season = "Inverno" [ set current-season "Primavera" ]

    ;; Altera o mapa com base na nova estação
    update-patches-for-season ; função de atualizar somente os pactches. N quis botar no recolor patches pra n ficar muita coisa ali e se der erro n dar muito problema.
    update-trees
  ]
end
to update-patches-for-season

  ask patches [
    if current-season = "Primavera" [
     if pcolor = white[
      set pcolor 63


    ]
      if pcolor = black[
      set pcolor 63

    ]]
    if current-season = "Verão" [
      if pcolor = 63[
      set pcolor 43

    ]]
    if current-season = "Outono" [ ; como a cor dai é predominante laranja, tive que modificar a cor base pra n dar problema na hora de aparecer as coisas.
      if pcolor = 43[
      set pcolor 23

    ]]
    if current-season = "Inverno" [
      if pcolor = 23[
      set pcolor white

    ]]
  ]
end
to update-trees
    if random 100 < 3[ ;%3 de spawnar
    create-lucas 1[;; easter egg
      setxy 0 0
      set size 4
    set color 136
      set shape "person soldier"
      set label "Lucas o intruso do formigueiro"
      set strenght 10000
      set life 100000
      set speed 1

    ]
  ]
  repeat num-predador[
  if random 100 < chancepredador[
      gerar-predador]]
  if current-season = "Primavera" [
  ask turtles with [shape = "tree"] [
      set color pink
      ]

      ask turtles with [shape = "tree"] [
    ; Para cada árvore, define patches ao redor como fontes de alimento
    let nearby-patches patches in-radius 9 ; Ajuste o raio conforme necessário
    ask nearby-patches [
      if random 100 < chancedomida [ ; 50% de chance de gerar comida em cada patch ao redor
        set food one-of [1 2] ; Define quantidade de comida aleatória (1 ou 2)
        set food-source-number [who] of myself ; Identifica a árvore como fonte de alimento
        if food = 1 [ set pcolor red ] ; Comida 1 -> vermelho
        if food = 2 [ set pcolor orange ]   ; Comida 2 -> laranja
        if food = 1[ set food-source-number 1]
        if food = 2[ set food-source-number 2]
      ]
    ]
  ]
  ]
  if current-season = "Verão" [
    ask turtles with [shape = "tree"] [
      set color 47
      ]

      ask turtles with [shape = "tree"] [
    ; Para cada árvore, define patches ao redor como fontes de alimento
    let nearby-patches patches in-radius 9 ; Ajuste o raio conforme necessário
    ask nearby-patches [
      if random 100 < chancedomida [ ; 50% de chance de gerar comida em cada patch ao redor
        set food one-of [1 2] ; Define quantidade de comida aleatória (1 ou 2)
        set food-source-number [who] of myself ; Identifica a árvore como fonte de alimento
        if food = 1 [ set pcolor red ] ; Comida 1 -> vermelho
        if food = 2 [ set pcolor orange ]   ; Comida 2 -> laranja
        if food = 1[ set food-source-number 1]
        if food = 2[ set food-source-number 2]
      ]
    ]
  ]
  ]
  if current-season = "Outono" [
       ask turtles with [shape = "tree"] [
      set color orange
      ]

      ask turtles with [shape = "tree"] [
    ; Para cada árvore, define patches ao redor como fontes de alimento
    let nearby-patches patches in-radius 9 ; Ajuste o raio conforme necessário
    ask nearby-patches [
      if random 100 < chancedomida [ ; 50% de chance de gerar comida em cada patch ao redor
        set food one-of [1 2] ; Define quantidade de comida aleatória (1 ou 2)
        set food-source-number [who] of myself ; Identifica a árvore como fonte de alimento
        if food = 1 [ set pcolor red ] ; Comida 1 -> vermelho
        if food = 2 [ set pcolor orange ]   ; Comida 2 -> laranja
        if food = 1[ set food-source-number 1]
        if food = 2[ set food-source-number 2]
      ]
    ]
  ]
  ]
  if current-season = "Inverno" [
       ask turtles with [shape = "tree"] [
      set color 8
      ]

  ] ; Com isso, qualquer ninho que n tiver comida guardada está ferrado! Sem Setup food e sem comidas aleatórias.
end

;=== Preadores=====
to gerar-predador ;pangolims-own [energy colony life strenght speed]

  ifelse random 100 < 50[ ; 50% de gerar um ou outro
  create-tamanduas random 2[
      set shape "tamandua"
      set color brown
      set size 17
      setxy random 40 random 40
      set energy 10000
      set colony "enemies"
      set life 1600
      set strenght 87
      set speed 1
  ]]
  [create-pangolims random 4 [
      set shape "pangolim"
      set color 37
      set size 12
      setxy random 40 random 40
      set energy 10000
      set colony "enemies"
      set life 700
      set strenght 48
      set speed 1.7

  ]]
  if predador-moron = true [
  if random 100 < chancemor[
   create-wolfs 1 + random 2 [
      set shape "wolf"
      set color 3
      set size 16
      setxy random 40 random 40
      set energy 10000
      set colony "enemies"
      set life 900
      set strenght 180
      set speed 2.6
  ]]]
end

to predar
  let predador turtles with [breed = tamanduas or breed = pangolims]
  let predador-mor turtles with [breed = wolfs]
  ask predador [
    let presas-proximas turtles with [breed = worker-ants or breed = soldier-ants or breed = queen-ants and distance myself < 3]

    if any? presas-proximas [
      let presa one-of presas-proximas
      face presa  ;; Vira-se para o inimigo
      fd 1                ;; Move-se 1 passo em direção ao inimigo
      ask presa [
        face self
        set life life - [strenght] of myself
      ]
    ]
  ]
  if predador-moron = true [
  ask predador-mor [
  let presas-proximas turtles with [breed = tamanduas or breed = pangolims and distance myself < 3]
    if any? presas-proximas [
      let presa one-of presas-proximas
      face presa  ;; Vira-se para o inimigo
      fd 1                ;; Move-se 1 passo em direção ao inimigo
      ask presa [
        face self
        set life life - [strenght] of myself
      ]
    ]
  ]]
end

;== Obstáculos ==
to setup-obstaculos
   ask patches [
  if random 10000 < 2[ ;; 10% de chance de o patch ser o centro de uma pedra
    ask patches in-radius 3 [ ;; Define os patches ao redor como parte da pedra
      set obstáculo? true
      set pcolor gray ;; Define a cor da pedra
    ]
  ]
]


end
to check-obstaculo
  ask turtles [
  let possible-patch one-of patches in-radius 1 with [not obstáculo?]
  if possible-patch != nobody [
    move-to possible-patch
  ]
]
end
to move-forward [steps]
  ;; Move-se para frente apenas se o patch à frente não for um obstáculo
   ;; Move-se para frente no máximo 'steps' passos, evitando obstáculos
  let moved 0
  while [moved < steps] [
    let next-patch patch-ahead 1
    ifelse next-patch != nobody and [not obstáculo?] of next-patch [
      fd 0.75
      set moved moved + 1
    ][
      ;; Se encontrar obstáculo, para de se mover
      stop
    ]
  ]

end

; === INFORMAÇÕES ADICIONAIS ===

; Este modelo simula o comportamento de formigas em busca de alimento e retorno ao ninho.
; As formigas deixam rastros de feromônio para guiar outras formigas às fontes de alimento.
; O feromônio evapora e difunde ao longo do tempo, criando um gradiente que as formigas seguem.

; === COPYRIGHT ===

; Copyright 1997 Uri Wilensky.
; Veja a aba 'Info' para o copyright completo e licença.
@#$#@#$#@
GRAPHICS-WINDOW
441
10
1268
838
-1
-1
7.0
1
10
1
1
1
0
0
0
1
-58
58
-58
58
1
1
1
ticks
30.0

BUTTON
46
71
126
104
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
31
106
221
139
diffusion-rate
diffusion-rate
0.0
99.0
53.0
1.0
1
NIL
HORIZONTAL

SLIDER
31
141
221
174
evaporation-rate
evaporation-rate
0.0
99.0
57.0
1.0
1
NIL
HORIZONTAL

BUTTON
136
71
211
104
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
31
36
221
69
population
population
0.0
200.0
25.0
1.0
1
NIL
HORIZONTAL

PLOT
5
197
248
476
Food in the map
time
food
0.0
50.0
0.0
120.0
true
false
"" ""
PENS
"food-in-pile1" 1.0 0 -2674135 true "" "plotxy ticks sum [food] of patches with [pcolor = red]"
"food-in-pile2" 1.0 0 -955883 true "" "plotxy ticks sum [food] of patches with [pcolor = orange]"

MONITOR
5
486
62
531
Formiga
count turtles
17
1
11

PLOT
233
33
433
183
Food in each nest
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Ninho 1" 1.0 0 -8630108 true "" "let total-food sum [food-store] of patches plot total-food"
"Ninho 2" 1.0 0 -13345367 true "" "let total-food sum [food-store2] of patches plot total-food"
"Ninho 3" 1.0 0 -4699768 true "" "let total-food sum [food-store3] of patches plot total-food"
"Ninho 4" 1.0 0 -1184463 true "" "let total-food sum [food-store4] of patches plot total-food"

SLIDER
260
215
432
248
Popsold
Popsold
0
200
11.0
1
1
NIL
HORIZONTAL

SLIDER
259
250
431
283
nascimentoformiga
nascimentoformiga
0
100
13.0
1
1
NIL
HORIZONTAL

SLIDER
259
290
431
323
Preçoconstrução
Preçoconstrução
0
200
51.0
1
1
NIL
HORIZONTAL

INPUTBOX
257
328
430
388
tamanhoseason
100.0
1
0
Number

SLIDER
260
410
432
443
chancedomida
chancedomida
0
100
13.0
1
1
NIL
HORIZONTAL

SLIDER
242
495
414
528
num-predador
num-predador
0
100
9.0
1
1
NIL
HORIZONTAL

SLIDER
67
493
239
526
chancepredador
chancepredador
0
100
18.0
1
1
NIL
HORIZONTAL

SWITCH
226
547
372
580
Predador-moron
Predador-moron
0
1
-1000

INPUTBOX
65
528
220
588
chancemor
10.0
1
0
Number

@#$#@#$#@
## WHAT IS IT?

In this project, a colony of ants forages for food. Though each ant follows a set of simple rules, the colony as a whole acts in a sophisticated way.

## HOW IT WORKS

When an ant finds a piece of food, it carries the food back to the nest, dropping a chemical as it moves. When other ants "sniff" the chemical, they follow the chemical toward the food. As more ants carry food to the nest, they reinforce the chemical trail.

## HOW TO USE IT

Click the SETUP button to set up the ant nest (in violet, at center) and three piles of food. Click the GO button to start the simulation. The chemical is shown in a green-to-white gradient.

The EVAPORATION-RATE slider controls the evaporation rate of the chemical. The DIFFUSION-RATE slider controls the diffusion rate of the chemical.

If you want to change the number of ants, move the POPULATION slider before pressing SETUP.

## THINGS TO NOTICE

The ant colony generally exploits the food source in order, starting with the food closest to the nest, and finishing with the food most distant from the nest. It is more difficult for the ants to form a stable trail to the more distant food, since the chemical trail has more time to evaporate and diffuse before being reinforced.

Once the colony finishes collecting the closest food, the chemical trail to that food naturally disappears, freeing up ants to help collect the other food sources. The more distant food sources require a larger "critical number" of ants to form a stable trail.

The consumption of the food is shown in a plot.  The line colors in the plot match the colors of the food piles.

## EXTENDING THE MODEL

Try different placements for the food sources. What happens if two food sources are equidistant from the nest? When that happens in the real world, ant colonies typically exploit one source then the other (not at the same time).

In this project, the ants use a "trick" to find their way back to the nest: they follow the "nest scent." Real ants use a variety of different approaches to find their way back to the nest. Try to implement some alternative strategies.

The ants only respond to chemical levels between 0.05 and 2.  The lower limit is used so the ants aren't infinitely sensitive.  Try removing the upper limit.  What happens?  Why?

In the `uphill-chemical` procedure, the ant "follows the gradient" of the chemical. That is, it "sniffs" in three directions, then turns in the direction where the chemical is strongest. You might want to try variants of the `uphill-chemical` procedure, changing the number and placement of "ant sniffs."

## NETLOGO FEATURES

The built-in `diffuse` primitive lets us diffuse the chemical easily without complicated code.

The primitive `patch-right-and-ahead` is used to make the ants smell in different directions without actually turning.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (1997).  NetLogo Ants model.  http://ccl.northwestern.edu/netlogo/models/Ants.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 1997 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

This model was created as part of the project: CONNECTED MATHEMATICS: MAKING SENSE OF COMPLEX PHENOMENA THROUGH BUILDING OBJECT-BASED PARALLEL MODELS (OBPML).  The project gratefully acknowledges the support of the National Science Foundation (Applications of Advanced Technologies Program) -- grant numbers RED #9552950 and REC #9632612.

This model was developed at the MIT Media Lab using CM StarLogo.  See Resnick, M. (1994) "Turtles, Termites and Traffic Jams: Explorations in Massively Parallel Microworlds."  Cambridge, MA: MIT Press.  Adapted to StarLogoT, 1997, as part of the Connected Mathematics Project.

This model was converted to NetLogo as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227. Converted from StarLogoT to NetLogo, 1998.

<!-- 1997 1998 MIT -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ant 2
true
0
Polygon -7500403 true true 150 19 120 30 120 45 130 66 144 81 127 96 129 113 144 134 136 185 121 195 114 217 120 255 135 270 165 270 180 255 188 218 181 195 165 184 157 134 170 115 173 95 156 81 171 66 181 42 180 30
Polygon -7500403 true true 150 167 159 185 190 182 225 212 255 257 240 212 200 170 154 172
Polygon -7500403 true true 161 167 201 150 237 149 281 182 245 140 202 137 158 154
Polygon -7500403 true true 155 135 185 120 230 105 275 75 233 115 201 124 155 150
Line -7500403 true 120 36 75 45
Line -7500403 true 75 45 90 15
Line -7500403 true 180 35 225 45
Line -7500403 true 225 45 210 15
Polygon -7500403 true true 145 135 115 120 70 105 25 75 67 115 99 124 145 150
Polygon -7500403 true true 139 167 99 150 63 149 19 182 55 140 98 137 142 154
Polygon -7500403 true true 150 167 141 185 110 182 75 212 45 257 60 212 100 170 146 172

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cow skull
false
0
Polygon -7500403 true true 150 90 75 105 60 150 75 210 105 285 195 285 225 210 240 150 225 105
Polygon -16777216 true false 150 150 90 195 90 150
Polygon -16777216 true false 150 150 210 195 210 150
Polygon -16777216 true false 105 285 135 270 150 285 165 270 195 285
Polygon -7500403 true true 240 150 263 143 278 126 287 102 287 79 280 53 273 38 261 25 246 15 227 8 241 26 253 46 258 68 257 96 246 116 229 126
Polygon -7500403 true true 60 150 37 143 22 126 13 102 13 79 20 53 27 38 39 25 54 15 73 8 59 26 47 46 42 68 43 96 54 116 71 126

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pangolim
false
0
Polygon -7500403 true true 86 145 100 171 98 194 110 213 98 239 82 249 93 262 106 264 113 254 139 208 158 209 188 209 218 239 217 250 210 255 204 262 207 270 218 271 241 273 248 254 247 209 262 194 277 164 263 134 233 104 173 89 98 104
Polygon -7500403 true true 123 149 122 101 92 100 69 95 44 105 12 160 17 165 54 147 81 137
Polygon -2064490 true false 53 130 61 143 19 168 12 156 25 141
Circle -16777216 true false 40 133 8
Polygon -16777216 true false 53 122 62 135 61 127 57 118 54 119 53 124
Polygon -7500403 true true 248 166 245 122 295 159 293 225 287 280 268 301 237 301 194 301 153 294 148 273 170 266 181 271 194 279 213 281 238 280 246 268 258 252 254 243 268 209 271 194 278 181 256 163 208 118
Polygon -16777216 false false 180 89 180 102 189 106 194 96
Polygon -16777216 false false 85 102 85 115 92 116 102 113
Polygon -16777216 false false 98 113 98 126 107 130 112 120
Polygon -16777216 false false 140 152 140 165 149 169 154 159
Polygon -16777216 false false 125 158 125 171 135 180 139 165
Polygon -16777216 false false 87 138 90 150 96 155 101 145
Polygon -16777216 false false 96 151 96 164 105 168 110 158
Polygon -16777216 false false 109 152 109 165 118 169 123 159
Polygon -16777216 false false 136 101 136 114 145 118 150 108
Polygon -16777216 false false 141 114 141 127 150 131 155 121
Polygon -16777216 false false 131 122 131 135 140 139 145 129
Polygon -16777216 false false 126 133 126 146 135 150 140 140
Polygon -16777216 false false 122 96 122 109 131 113 136 103
Polygon -16777216 false false 113 137 113 150 122 154 127 144
Polygon -16777216 false false 111 119 111 132 120 136 125 126
Polygon -16777216 false false 117 108 117 121 126 125 131 115
Polygon -16777216 false false 105 100 105 113 114 117 119 107
Polygon -16777216 false false 99 130 99 143 108 147 113 137
Polygon -16777216 false false 178 141 178 154 187 158 192 148
Polygon -16777216 false false 170 126 170 139 179 143 184 133
Polygon -16777216 false false 150 144 150 157 159 161 164 151
Polygon -16777216 false false 111 220 111 233 120 237 125 227
Polygon -16777216 false false 100 215 100 228 109 232 114 222
Polygon -16777216 false false 117 206 117 219 126 223 131 213
Polygon -16777216 false false 110 193 110 206 119 210 124 200
Polygon -16777216 false false 144 180 144 193 153 197 158 187
Polygon -16777216 false false 133 180 133 193 142 197 147 187
Polygon -16777216 false false 124 190 124 203 133 207 138 197
Polygon -16777216 false false 125 147 125 160 134 164 139 153
Polygon -16777216 false false 110 182 110 195 119 199 124 189
Polygon -16777216 false false 107 169 107 182 116 186 121 176
Polygon -16777216 false false 140 90 140 103 149 107 154 97
Polygon -16777216 false false 151 89 151 102 160 106 165 96
Polygon -16777216 false false 162 90 162 103 171 107 176 97
Polygon -16777216 false false 164 108 164 121 173 125 178 115
Polygon -16777216 false false 151 102 151 115 160 119 165 109
Polygon -16777216 false false 155 119 155 132 164 136 169 126
Polygon -16777216 false false 163 165 163 178 172 182 177 172
Polygon -16777216 false false 138 166 138 179 147 183 152 173
Polygon -16777216 false false 150 166 150 179 159 183 164 173
Polygon -16777216 false false 165 150 165 163 174 167 179 157
Polygon -16777216 false false 163 136 163 149 172 153 177 143
Polygon -16777216 false false 145 130 145 143 154 147 159 137
Polygon -16777216 false false 138 139 138 152 147 156 152 146
Polygon -16777216 false false 220 115 220 128 227 129 237 126
Polygon -16777216 false false 211 103 211 116 218 117 228 114
Polygon -16777216 false false 217 158 217 171 224 172 234 169
Polygon -16777216 false false 210 149 210 162 217 163 220 159
Polygon -16777216 false false 214 168 214 181 221 182 231 179
Polygon -16777216 false false 234 164 234 177 241 178 251 175
Polygon -16777216 false false 228 174 228 187 235 188 245 185
Polygon -16777216 false false 222 183 222 196 229 197 239 194
Polygon -16777216 false false 83 115 83 128 90 129 100 126
Polygon -16777216 false false 98 142 98 129 91 128 81 131
Polygon -16777216 false false 202 139 202 152 209 153 219 150
Polygon -16777216 false false 207 115 207 128 214 129 224 126
Polygon -16777216 false false 211 190 211 203 218 204 228 201
Polygon -16777216 false false 200 197 200 210 207 211 217 208
Polygon -16777216 false false 195 98 195 111 202 112 212 109
Polygon -16777216 false false 194 182 194 195 201 196 211 193
Polygon -16777216 false false 179 184 179 197 186 198 196 195
Polygon -16777216 false false 192 170 192 183 199 184 209 181
Polygon -16777216 false false 195 160 195 173 202 174 212 171
Polygon -16777216 false false 193 145 193 158 200 159 210 156
Polygon -16777216 false false 197 124 197 137 204 138 214 135
Polygon -16777216 false false 191 106 191 119 198 120 208 117
Polygon -16777216 false false 158 194 153 203 160 204 170 201
Polygon -16777216 false false 161 186 163 196 168 200 178 197
Polygon -16777216 false false 162 175 162 188 169 189 179 186
Polygon -16777216 false false 175 173 175 186 182 187 192 184
Polygon -16777216 false false 180 160 180 173 187 174 197 171
Polygon -16777216 false false 187 129 187 142 194 143 204 140
Polygon -16777216 false false 179 114 179 127 186 128 196 125
Polygon -16777216 false false 175 99 175 112 182 113 192 110
Polygon -16777216 false false 263 142 263 155 270 156 280 153
Polygon -16777216 false false 249 128 249 141 256 142 266 139
Polygon -16777216 false false 257 161 257 174 264 175 274 172
Polygon -16777216 false false 235 117 235 130 242 131 252 128
Polygon -16777216 false false 257 150 257 163 264 164 274 161
Polygon -16777216 false false 247 180 247 193 254 194 264 191
Polygon -16777216 false false 232 212 232 225 239 226 249 223
Polygon -16777216 false false 223 220 223 233 230 234 240 231
Polygon -16777216 false false 230 230 230 243 237 244 247 241
Polygon -16777216 false false 204 210 204 223 211 224 221 221
Polygon -16777216 false false 221 198 221 211 228 212 238 209
Polygon -16777216 false false 230 192 230 205 237 206 247 203
Polygon -16777216 false false 244 137 244 150 251 151 261 148
Polygon -16777216 false false 218 124 218 137 225 138 235 135
Polygon -16777216 false false 231 129 231 142 238 143 248 140
Polygon -16777216 false false 234 147 234 160 241 161 251 158
Polygon -16777216 false false 216 289 216 302 225 306 230 296
Polygon -16777216 false false 219 277 219 290 228 294 233 284
Polygon -16777216 false false 203 289 203 302 212 306 217 296
Polygon -16777216 false false 209 279 209 292 218 296 223 286
Polygon -16777216 false false 117 108 117 121 126 125 131 115
Polygon -16777216 false false 195 277 195 290 204 294 209 284
Polygon -16777216 false false 189 286 189 299 198 303 203 293
Polygon -16777216 false false 183 272 183 285 192 289 197 279
Polygon -16777216 false false 176 282 176 295 185 299 190 289
Polygon -16777216 false false 155 279 155 292 164 296 169 286
Polygon -16777216 false false 163 276 163 289 172 293 177 283
Polygon -16777216 false false 172 268 172 281 181 285 186 275
Polygon -16777216 false false 159 265 159 278 168 282 173 272
Polygon -16777216 false false 148 268 148 281 157 285 162 275
Polygon -16777216 false false 253 289 253 302 262 306 267 296
Polygon -16777216 false false 259 282 259 295 268 299 273 289
Polygon -16777216 false false 267 274 267 287 276 291 281 281
Polygon -16777216 false false 273 248 273 261 282 265 287 255
Polygon -16777216 false false 274 233 274 246 283 250 288 240
Polygon -16777216 false false 277 222 277 235 286 239 291 229
Polygon -16777216 false false 281 209 281 222 290 226 295 216
Polygon -16777216 false false 282 197 282 210 291 214 296 204
Polygon -16777216 false false 284 180 284 193 293 197 298 187
Polygon -16777216 false false 277 171 277 184 286 188 291 178
Polygon -16777216 false false 273 182 273 195 282 199 287 189
Polygon -16777216 false false 269 194 269 207 278 211 283 201
Polygon -16777216 false false 267 209 267 222 276 226 281 216
Polygon -16777216 false false 262 220 262 233 271 237 276 227
Polygon -16777216 false false 257 229 257 242 266 246 271 236
Polygon -16777216 false false 255 241 255 254 264 258 269 248
Polygon -16777216 false false 253 255 253 268 262 272 267 262
Polygon -16777216 false false 254 268 254 281 263 285 268 275
Polygon -16777216 false false 246 277 246 290 255 294 260 284
Polygon -16777216 false false 244 262 244 275 253 279 258 269
Polygon -16777216 false false 240 287 240 300 249 304 254 294
Polygon -16777216 false false 240 273 237 283 246 287 251 277
Polygon -16777216 false false 230 292 230 305 239 309 244 299
Polygon -16777216 false false 230 280 230 293 239 297 244 287
Polygon -16777216 false false 275 150 275 163 284 167 289 157
Polygon -16777216 false false 271 156 271 169 280 173 285 163
Polygon -16777216 false false 122 173 122 186 131 190 136 180
Polygon -16777216 false false 98 142 98 129 91 128 81 131
Polygon -16777216 false false 98 142 98 129 91 128 81 131
Polygon -16777216 false false 270 272 277 267 270 266 260 269
Polygon -16777216 false false 286 285 286 272 279 271 269 274
Polygon -16777216 false false 273 248 273 261 282 265 287 255
Polygon -16777216 false false 274 257 274 270 283 274 288 264
Polygon -16777216 false false 284 160 284 173 293 177 298 167
Polygon -16777216 false false 267 237 267 250 276 254 281 244
Polygon -16777216 false false 265 251 265 264 274 268 279 258
Polygon -16777216 false false 105 100 105 113 114 117 119 107
Polygon -16777216 false false 31 128 26 137 34 137 40 131
Polygon -16777216 false false 34 118 34 131 43 131 48 125
Polygon -16777216 false false 43 107 43 120 52 124 57 114
Polygon -16777216 false false 52 100 52 113 61 117 66 107
Polygon -16777216 false false 61 123 61 136 70 140 75 130
Polygon -16777216 false false 92 97 92 110 101 114 106 104
Polygon -16777216 false false 63 111 63 124 72 128 77 118
Polygon -16777216 false false 61 96 61 109 70 113 75 103
Polygon -16777216 false false 72 121 72 134 81 138 86 128
Polygon -16777216 false false 74 108 74 121 83 125 88 115
Polygon -16777216 false false 72 93 72 106 81 110 86 100
Polygon -16777216 true false 90 252 117 266 111 264 94 264 82 251 87 250
Polygon -16777216 true false 204 262 220 269 240 271 239 274 204 271 203 260
Polygon -16777216 false false 217 136 217 149 224 150 234 147
Polygon -16777216 false false 245 162 240 165 254 179 259 168
Polygon -16777216 false false 214 227 214 240 223 244 228 234

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

squirrel
false
0
Polygon -7500403 true true 87 267 106 290 145 292 157 288 175 292 209 292 207 281 190 276 174 277 156 271 154 261 157 245 151 230 156 221 171 209 214 165 231 171 239 171 263 154 281 137 294 136 297 126 295 119 279 117 241 145 242 128 262 132 282 124 288 108 269 88 247 73 226 72 213 76 208 88 190 112 151 107 119 117 84 139 61 175 57 210 65 231 79 253 65 243 46 187 49 157 82 109 115 93 146 83 202 49 231 13 181 12 142 6 95 30 50 39 12 96 0 162 23 250 68 275
Polygon -16777216 true false 237 85 249 84 255 92 246 95
Line -16777216 false 221 82 213 93
Line -16777216 false 253 119 266 124
Line -16777216 false 278 110 278 116
Line -16777216 false 149 229 135 211
Line -16777216 false 134 211 115 207
Line -16777216 false 117 207 106 211
Line -16777216 false 91 268 131 290
Line -16777216 false 220 82 213 79
Line -16777216 false 286 126 294 128
Line -16777216 false 193 284 206 285

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

tamandua
false
0
Polygon -7500403 true true 45 60 30 45 45 30 75 45 90 75
Polygon -7500403 true true 255 60 270 45 255 30 225 45 210 75
Circle -16777216 true false 183 138 24
Circle -16777216 true false 93 138 24
Polygon -7500403 true true 60 75 75 120 90 165 120 240 120 300 180 300 180 240 210 165 225 120 240 75 240 0 60 0
Circle -16777216 true false 90 135 30
Circle -16777216 true false 180 135 30
Rectangle -7500403 true true 150 270 150 300
Polygon -16777216 true false 60 60 105 30
Polygon -2064490 true false 150 285 150 300 180 300 210 300 225 285 225 240 210 255 210 285 210 285 165 285 150 285
Polygon -16777216 true false 240 45 240 45 255 45 240 60 240 45 240 45
Rectangle -16777216 true false 135 285 165 300
Polygon -16777216 true false 60 45 60 45 45 45 60 60 60 45 60 45

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -7500403 true true 75 225 97 249 112 252 122 252 114 242 102 241 89 224 94 181 64 113 46 119 31 150 32 164 61 204 57 242 85 266 91 271 101 271 96 257 89 257 70 242
Polygon -7500403 true true 216 73 219 56 229 42 237 66 226 71
Polygon -7500403 true true 181 106 213 69 226 62 257 70 260 89 285 110 272 124 234 116 218 134 209 150 204 163 192 178 169 185 154 189 129 189 89 180 69 166 63 113 124 110 160 111 170 104
Polygon -6459832 true false 252 143 242 141
Polygon -6459832 true false 254 136 232 137
Line -16777216 false 75 224 89 179
Line -16777216 false 80 159 89 179
Polygon -6459832 true false 262 138 234 149
Polygon -7500403 true true 50 121 36 119 24 123 14 128 6 143 8 165 8 181 7 197 4 233 23 201 28 184 30 169 28 153 48 145
Polygon -7500403 true true 171 181 178 263 187 277 197 273 202 267 187 260 186 236 194 167
Polygon -7500403 true true 187 163 195 240 214 260 222 256 222 248 212 245 205 230 205 155
Polygon -7500403 true true 223 75 226 58 245 44 244 68 233 73
Line -16777216 false 89 181 112 185
Line -16777216 false 31 150 47 118
Polygon -16777216 true false 235 90 250 91 255 99 248 98 244 92
Line -16777216 false 236 112 246 119
Polygon -16777216 true false 278 119 282 116 274 113
Line -16777216 false 189 201 203 161
Line -16777216 false 90 262 94 272
Line -16777216 false 110 246 119 252
Line -16777216 false 190 266 194 274
Line -16777216 false 218 251 219 257
Polygon -16777216 true false 230 67 228 54 222 62 224 72
Line -16777216 false 246 67 234 64
Line -16777216 false 229 45 235 68
Line -16777216 false 30 150 30 165

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
