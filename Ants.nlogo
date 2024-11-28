; === INSTRUÇÕES ===
; === DEFINIÇÃO DE VARIÁVEIS ===
;Classes das formigas
breed [worker-ants worker-ant]  ; Formigas Trabalhadoras
breed [soldier-ants soldier-ant] ; Formigas Guerreiras
breed [queen-ants queen-ant] ; Formigas rainha
breed [trees tree] ; Arvore
breed [nests nest]  ; Ninho pras formigas
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
]
; Forma da Formiga ter energia e morrer, além dos atributos que eu criei
worker-ants-own [energy colony life strenght mutation speed carrying-food]
soldier-ants-own [energy colony life strenght mutation speed]
queen-ants-own [energy colony life strenght mutation speed]
trees-own [energy]
; === PROCEDIMENTOS DE CONFIGURAÇÃO ===
to setup
  clear-all                            ; limpa o mundo e reinicia a simulação
  reset-ticks

  set-default-shape worker-ants "bug"       ; define o formato das formigas como "inseto"
   set-default-shape soldier-ants "bug"       ; define o formato das formigas como "inseto"
   set-default-shape queen-ants "bug"       ; define o formato das formigas como "inseto"
  ;repeat 4 [
  let colony-colors [violet blue 126 yellow] ; Cada ninho tem uma cor única
    foreach colony-colors [colony-color ->
  create-worker-ants population [           ; cria formigas com base no valor do slider 'population'
    set carrying-food false
    set size 1                          ; tamanho base
    set color colony-color                       ; vermelho indica que não está carregando comida
    set energy 1000                       ; da a energia da formiga
    set colony colony-color ; atribui a colônia
    aplicar-atributos
  ]
    create-soldier-ants 10 [
    set size 2                          ; aumenta o tamanho para melhor visualização
    set color colony-color + 3                      ; formiga soldado é magenta (tirei a cor do site lá) um pouco diferente do trabalhador
    set energy 1000                       ; da a energia da formiga
    set colony colony-color ; atribui a colônia
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
    set size 3                         ; aumenta o tamanho para melhor visualização
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
  reset-ticks                           ; reinicia o contador de tempo da simulação
end

to setup-patches
  ask patches [
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
    set speed 2
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
    set speed 3
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
    set speed 1
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
      if random 100 < 50 [ ; 50% de chance de gerar comida em cada patch ao redor
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

       if max-chemical = chemical [ set pcolor scale-color 117 chemical 0.1 5 ] ;violeta claro (decidi deixar os feromonios relacionados com as cores pra n ficar um inferno na tela)
      if max-chemical = chemical2 [ set pcolor scale-color cyan chemical2 0.1 5 ] ;variação de azul
      if max-chemical = chemical3 [ set pcolor scale-color 137 chemical3 0.1 5 ] ;magenta é daqui pra lá pra rosa.
      if max-chemical = chemical4 [ set pcolor scale-color 48 chemical4 0.1 5 ] ; amarelo n tem pra onde fugir n, netlogo n tem muitas cores de amarelo .-.
      ]
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
    fd 1                                 ; move-se para frente
    set energy energy - 2                ; Diminui a energia delas
  ]

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

      rt 180
    ] [
      set chemical chemical + 60        ; Libera feromônio no caminho
      uphill-nest-scent                 ; Move-se na direção do ninho
    ]

end
to return-to-nest2
    ifelse nest2? [
      set color blue                    ; Deposita comida e volta à cor original

      rt 180
    ] [
      set chemical2 chemical2 + 60      ; Libera feromônio no caminho
      uphill-nest-scent2                ; Move-se na direção do ninho
    ]

end
to return-to-nest3
    ifelse nest3? [
      set color 126                     ; Deposita comida e volta à cor original
                ; Indica que não está mais carregando comida
      rt 180
    ] [
      set chemical3 chemical3 + 60      ; Libera feromônio no caminho
      uphill-nest-scent3                ; Move-se na direção do ninho
    ]

end
to return-to-nest4

    ifelse nest4? [
      set color yellow                  ; Deposita comida e volta à cor original

      rt 180
    ] [
      set chemical4 chemical4 + 60      ; Libera feromônio no caminho
      uphill-nest-scent4                ; Move-se na direção do ninho
    ]

end


to check-death ;ver se a formiga vai morrer
  ask worker-ants [
    if energy <= 0 [ die ]
  ]
    ask soldier-ants [
    if energy <= 0 [ die ]
  ]
  ask queen-ants [
    if energy <= 0 [ die ]
  ]
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
    fd 1
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
    fd 1
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
end

to wiggle  ; procedimento das formigas
  rt random 45                           ; vira um ângulo aleatório à direita
  lt random 45                           ; vira um ângulo aleatório à esquerda
  if not can-move? 1 [ rt 180 ]          ; se não puder se mover, vira 180 graus
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
50.0
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
10.0
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
36
23
226
56
population
population
0.0
200.0
29.0
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

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

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
