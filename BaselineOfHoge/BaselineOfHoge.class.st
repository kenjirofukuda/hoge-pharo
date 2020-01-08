Class {
	#name : #BaselineOfHoge,
	#superclass : #BaselineOf,
	#category : #BaselineOfHoge
}

{ #category : #baselines }
BaselineOfHoge >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec package: #'Hoge'.
			spec
				configuration: 'OSProcess'
					with: [ 
						spec
							versionString: #stable;
							repository: 'http://www.squeaksource.com/MetacelloRepository' ].
			spec
				configuration: 'NeoCSV'
					with: [ 
						spec
							versionString: #stable;
							repository: 'http://mc.stfx.eu/Neo' ].
			spec
				package: 'GeometryUtils'
				with: [ spec repository: 'github://kenjirofukuda/geom-pharo:Pharo6.1' ] ]
]
