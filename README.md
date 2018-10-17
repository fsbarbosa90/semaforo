# Semáforo 
Classe em advpl para controlar as rotinas que devem executar de forma excluisa


#Descrição
Fonte ADVPL Protheus 12. Função vai controlar para que uma rotina não execute simultaneamente, 
para garantir a integridade dos dados que estão sendo gerados por ela.

#Exemplo de Uso

User Function IMPORTACAODEPV
****************************
Local oSemaforo :=  Semaforo():New() 

//VAI SETAR O NOME DA FUNCAO QUE VAI BLOQUEAR
oSemaforo:setName("IMPORTACAODEPV")


oSemaforo:setTry(10)//NUMERO DE TENTATIVAS QUE O SISTEMA VAI TENTAR O BLOQUEIO EXCLUISIVO DA ROTINA


oSemaforo:setSleep(500)//TEMPO ENTRE AS TENTATIVAS MILESEGUNDOS


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
