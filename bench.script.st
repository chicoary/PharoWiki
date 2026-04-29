| sizes selectedPackages string |

"Tamanhos de cache a comparar"
sizes := #(50 100 250 500 1000 2000 5000).

"Selecionar 5 pacotes aleatórios com >= 10 classes"
selectedPackages := (PackageOrganizer default packages
    select: [ :pkg | pkg classes size >= 10 ])
    asSortedCollection: [ :a :b | a name < b name ].
selectedPackages := selectedPackages asArray shuffled first: 5.

Transcript
    show: '=== PharoWiki — Cache Benchmark ==='; cr;
    show: 'Pacotes: ', (selectedPackages collect: [ :p | p name ]) asString; cr;
    show: 'Total de classes: ',
        (selectedPackages inject: 0 into: [ :sum :p | sum + p classes size ]) asString; cr;
    cr.

"Cabeçalho da tabela"
Transcript
    show: ('MaxWeight' padRightTo: 12);
    show: ('Hits' padRightTo: 10);
    show: ('Misses' padRightTo: 10);
    show: ('HitRatio%' padRightTo: 12);
    show: ('CacheSize' padRightTo: 12);
    cr;
    show: (String new: 56 withAll: $-); cr.

"Rodar ensaio para cada tamanho"
[ :outerJob |
    outerJob title: 'Cache Benchmark'.
    outerJob min: 0; max: sizes size.

    sizes doWithIndex: [ :maxWeight :sizeIndex |
        | cache |
        outerJob current: sizeIndex.
        outerJob title: 'Cache Benchmark — MaxWeight: ', maxWeight asString.

        cache := LRUCache new.
        cache maximumWeight: maxWeight.

        [ :innerJob |
            innerJob title: 'MaxWeight ', maxWeight asString.
            innerJob min: 0; max: selectedPackages size.

            selectedPackages doWithIndex: [ :pkg :pkgIndex |
                innerJob current: pkgIndex.
                innerJob title: pkg name.

                pkg classes do: [ :cls |
                    cls methods do: [ :method |
                        cache
                            at: method selector
                            ifAbsentPut: [
                                SystemNavigation default allImplementorsOf: method selector ] ] ] ] ]
        asJob run.

			string := (cache hitRatio * 100.0) rounded asString, ' %'.
		
        Transcript
            show: (maxWeight asString padRightTo: 12);
            show: (cache hits asString padRightTo: 10);
            show: (cache misses asString padRightTo: 10);
            show: (string padRightTo: 12);
            show: (cache size asString padRightTo: 12);
            cr ] ]
asJob run.

Transcript show: '=== Fim ==='; cr.