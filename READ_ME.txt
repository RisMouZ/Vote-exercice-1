Dans la version 1 j'ai fait un systeme de vote blanc, la Proposal "blank vote" étant ajoutée dans le proposalArray grâce au constructor.

L'élection se déroule comme demandé, à l'inscription des adresses whitelistées celles-ci sont stockée dans un tableau afin de pouvoir bouclé dessus dans la dernière 
fonction en cas de vote blanc, les adresses whitelistées peuvent proposer autant de Proposal souhaitées.

Si le vainqueur de l'élection est l'id 0 (le vote blanc) l'administrateur peut lancer la fonction resetVote avec la valeur "blank vote" en paramètre 
afin de reset le tableau de proposition et d'y inseret "blank vote" en id 0, les structures Voter liées aux adresses correspondantes sont remises au statut de départ
évitant ainsi de ressaisir toute la whitelist, le WorkFlowStatut est egalement remis à 0 afin de pouvoir rajouter des adresses à whitlister si besoin.

Sinon un vainqueur est trouvé.




Pour la version 2 je suis partis dans l'idée qu'au lieu d'autoriser les propositions illimitées des whitelistés on pouvait limiter chaque adresse à une seule proposition,
devenant donc plutôt une candidature.

Un mapping est donc exécuté afin de savoir qui est candidat.

Le vote se déroule normalement.

Si un candidat est trouvé bravo à lui. Sinon, le vote blanc l'emportant, l'élection est relancé comme dans la version 1 à l'exception des candidats précédents ne pouvant 
pas se représenter, n'ayant pas convaincu, afin de recommencer l'élection avec des idées neuves.
