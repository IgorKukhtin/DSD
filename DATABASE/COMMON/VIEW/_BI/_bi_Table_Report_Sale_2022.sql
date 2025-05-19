DO $$
BEGIN

-- *** 1 - '01.01.2022' AND '28.02.2022'
INSERT INTO _bi_Table_Report_Sale
            (
              -- Id ���������
              MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              InvNumber      ,

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 
             )

       SELECT MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              zfConvert_StringToNumber (InvNumber),

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 

FROM _bi_Report_Sale_View

WHERE OperDate BETWEEN '01.01.2022' AND '28.02.2022'
;


-- *** 2 - '01.03.2022' AND '30.04.2022'
  INSERT INTO _bi_Table_Report_Sale
            (
              -- Id ���������
              MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              InvNumber      ,

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 
             )

       SELECT MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              zfConvert_StringToNumber (InvNumber),

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 

FROM _bi_Report_Sale_View

WHERE OperDate BETWEEN '01.03.2022' AND '30.04.2022'
;


-- *** 3 - '01.05.2022' AND '30.06.2022'
  INSERT INTO _bi_Table_Report_Sale
            (
              -- Id ���������
              MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              InvNumber      ,

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 
             )

       SELECT MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              zfConvert_StringToNumber (InvNumber),

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 

FROM _bi_Report_Sale_View

WHERE OperDate BETWEEN '01.05.2022' AND '30.06.2022'
;


-- *** 4 - '01.07.2022' AND '31.08.2022'
  INSERT INTO _bi_Table_Report_Sale
            (
              -- Id ���������
              MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              InvNumber      ,

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 
             )

       SELECT MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              zfConvert_StringToNumber (InvNumber),

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 

FROM _bi_Report_Sale_View

WHERE OperDate BETWEEN '01.07.2022' AND '31.08.2022'
;


-- *** 5 - '01.09.2022' AND '31.10.2022'
  INSERT INTO _bi_Table_Report_Sale
            (
              -- Id ���������
              MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              InvNumber      ,

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 
             )

       SELECT MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              zfConvert_StringToNumber (InvNumber),

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 

FROM _bi_Report_Sale_View

WHERE OperDate BETWEEN '01.09.2022' AND '31.10.2022'
;

-- *** 6 - '01.11.2022' AND '31.12.2022'
  INSERT INTO _bi_Table_Report_Sale
            (
              -- Id ���������
              MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              InvNumber      ,

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 
             )

       SELECT MovementId     ,
              -- ��� ���������
              MovementDescId ,
              -- ���� ����������
              OperDate       ,
              -- ���� �����
              OperDate_sklad ,
              -- � ���������
              zfConvert_StringToNumber (InvNumber),

              -- ��. ����
              JuridicalId    ,
              -- ����������
              PartnerId      ,

              -- �� ������ ����������
              InfoMoneyId    ,
              -- ����� ������
              PaidKindId     ,
              -- ������
              BranchId       ,
              -- �������
              ContractId     ,

              -- �����
              GoodsId        ,
              -- ��� ������
              GoodsKindId    ,


              -- �������� ������ ����������
              MovementId_order    ,

              -- �������� �����
              MovementId_promo    ,


              -- ��� ������� - �� ������
              Sale_Amount         ,
              -- ��.
              Sale_Amount_sh      ,

              -- ��� ������� - �� �����
              Return_Amount      ,
              -- ��.
              Return_Amount_sh   ,


              -- ����� - ��� �������
              AmountPartner_promo      ,
              -- ��.
              AmountPartner_promo_sh   ,

              -- ��� ������� � ����������
              Sale_AmountPartner       ,
              -- ��.
              Sale_AmountPartner_sh    ,

              -- ��� ������� � ����������
              Return_AmountPartner     ,
              -- ��.
              Return_AmountPartner_sh  ,

              -- ��� ������ �� ��� - �������
              Sale_Amount_10500        ,
              -- ��.
              Sale_Amount_10500_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Sale_Amount_40200        ,
              -- ��.
              Sale_Amount_40200_sh     ,

              -- ��� ������ - ������� � ���� - �������
              Return_Amount_40200      ,
              -- ��.
              Return_Amount_40200_sh   ,


              -- ����� - ����� �������
              Sale_Summ_promo       ,
              -- ����� �������
              Sale_Summ             ,
              -- ����� �������
              Return_Summ           ,

              -- ����� ������� - ������� �� ���� ������ ��� (������-�����������)
              Sale_Summ_10200       ,
              -- ����� ������� - ������-�����
              Sale_Summ_10250       ,
              -- ����� ������� - ������-�������������� (% � �.�.)
              Sale_Summ_10300       ,

              -- ����� ������� - ������-�������������� (% � �.�.)
              Return_Summ_10300     ,

              -- ����� - ����� �/� �������
              Sale_SummCost_promo   ,


              -- ����� �/� �������
              Sale_SummCost         ,
              -- ����� �/� ������ �� ��� - �������
              Sale_SummCost_10500   ,
              -- ����� �/� ������ - ������� � ���� - �������
              Sale_SummCost_40200   ,

              -- ����� �/� �������
              Return_SummCost       ,
              -- ����� �/� ������ - ������� � ���� - �������
              Return_SummCost_40200 

FROM _bi_Report_Sale_View

WHERE OperDate BETWEEN '01.11.2022' AND '31.12.2022'
;

END;
$$;
