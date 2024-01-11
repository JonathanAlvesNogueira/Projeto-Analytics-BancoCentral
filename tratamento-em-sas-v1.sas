LIBNAME JONY '/home/u63480479/my_shared_file_links/u63480479';

DATA JONY.BACEN_DADOS_IMOVEIS;
SET WORK.'202310Bens_Imoveis_Grupos'n;
RUN;

DATA BASE_ANALISE;
SET JONY.BACEN_DADOS_IMOVEIS;
	
	FORMAT NOVA $30.;
	IF 'Taxa_de_administração'n > 20 THEN NOVA = 'VALOR-ACIMA';
									 ELSE NOVA = 'VALOR-NORMAL';

 	format NOME_ADM $60.;
	Nome_adm = '#Nome_da_administradora'n ;


RUN;

PROC SQL OUTOBS=5;
    CREATE TABLE BASE_ANALISE_2 AS
    SELECT
        NOME_ADM
        ,CNPJ_DA_ADMINISTRADORA
		,COUNT(*) AS QTD
		,SUM(Quantidade_de_cotas_ativas_com_c) AS QTD_COTAS_ATIVAS 
		,SUM(Quantidade_de_cotas_ativas_quita) AS QTD_COTAS_QUITADAS
		,SUM(Quantidade_de_cotas_excluídas) AS QTD_COTAS_EXCLUIDAS
		,SUM(Quantidade_de_cotas_ativas_conte) AS QTD_COTAS_AT_CONTEMP
		,MEAN(Valor_médio_do_bem) AS TICKET_MEDIO
		,MAX(Taxa_de_administração) AS MAIOR_TAXA_ADM
		,MAX(Prazo_do_grupo_em_meses) AS MAIOR_PRAZO_MESES
    FROM BASE_ANALISE
    GROUP BY NOME_ADM
        	,CNPJ_DA_ADMINISTRADORA
	ORDER BY QTD DESC
;
QUIT;


