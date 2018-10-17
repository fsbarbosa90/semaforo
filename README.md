# Semáforo 
Classe em advpl para controlar as rotinas que devem executar de forma excluisa


#Descrição
Fonte ADVPL Protheus 12. Função vai controlar para que uma rotina não execute simultaneamente, 
para garantir a integridade dos dados que estão sendo gerados por ela.

#Exemplo de Uso

User Function IMPORTACAODEPV



Local oSemaforo :=  Semaforo():New() 




//NOME DA FUNCAO




oSemaforo:setName("IMPORTACAODEPV")



//NUMERO DE TENTATIVAS DE BLOQUEIO



oSemaforo:setTry(10)



//TEMPO ENTRE AS TENTATIVAS MILESEGUNDOS



oSemaforo:setSleep(500)




// +--------------------------------+
// | TENTA BLOQUEAR O USO DA ROTINA |
// +--------------------------------+


If !oSemaforo:LockData()
  FreeObj(oSemaforo)
	Return .F.
EndIf




    // AQUI VAI SUA ROTINA OU CHAMADOS E FUNCOES QUE DESEJA EXECUTAR, 
    //POIS SE A MEMA FOR CHAMADA NOVAMENTE NAO VAI LIBERAR POIS O SEMAFORO ESTA ACIMA CUIDANDO DOS ACESSOS



// +-----------------------------+
// | TIRA O CONTROLE DE SEMAFORO |
// +-----------------------------+



oSemaforo:Destroy()
FreeObj(oSemaforo)




Return .T.
