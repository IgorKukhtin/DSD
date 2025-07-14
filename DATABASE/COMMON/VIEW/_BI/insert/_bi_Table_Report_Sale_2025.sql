DO $$
BEGIN

-- *** 1 - '01.01.2025' AND '31.01.2025'
INSERT INTO _bi_Table_Report_Sale_2025
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

WHERE OperDate BETWEEN '01.01.2025' AND '31.01.2025'
;


-- *** 2 - '01.02.2025' AND '28.02.2025'
  INSERT INTO _bi_Table_Report_Sale_2025
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

WHERE OperDate BETWEEN '01.02.2025' AND '28.02.2025'
;


-- *** 3 - '01.03.2025' AND '31.03.2025'
  INSERT INTO _bi_Table_Report_Sale_2025
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

WHERE OperDate BETWEEN '01.03.2025' AND '31.03.2025'
;


-- *** 4 - '01.04.2025' AND '30.04.2025'
  INSERT INTO _bi_Table_Report_Sale_2025
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

WHERE OperDate BETWEEN '01.04.2025' AND '30.04.2025'
;


-- *** 5 - '01.05.2025' AND '31.05.2025'
  INSERT INTO _bi_Table_Report_Sale_2025
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

WHERE OperDate BETWEEN '01.05.2025' AND '17.05.2025'
;


END;
$$;
