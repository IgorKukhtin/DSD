-- Function: gpinsert_bi_table_sale(tdatetime, tdatetime, tvarchar)

-- DROP FUNCTION gpinsert_bi_table_sale(tdatetime, tdatetime, tvarchar);

CREATE OR REPLACE FUNCTION gpinsert_bi_table_sale(
    instartdate tdatetime,
    inenddate tdatetime,
    insession tvarchar)
  RETURNS void AS
$BODY$
BEGIN
      -- inStartDate:='01.01.2025';
      --

      IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) NOT IN (11) OR 1=1
      THEN
          DELETE FROM _bi_Table_Report_Sale_2025 WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- ������� - ��������� ����� - 2025 ���
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
            WHERE OperDate BETWEEN inStartDate AND inEndDate
           ;

  -- ��������
  INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        SELECT inSession :: Integer AS UserId
               -- �� ������� ��������
             , CURRENT_TIMESTAMP
             , 0 AS Value1
             , 0 AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- ������� ����� ����������� ����
             , (CLOCK_TIMESTAMP() - CURRENT_TIMESTAMP) :: INTERVAL AS Time1
               -- ������� ����� ����������� ���� �� 
             , NULL AS Time2
               -- ������� ����� ����������� ���� 
             , NULL AS Time3
               -- ������� ����� ����������� ���� ����� 
             , NULL AS Time4
               -- �� ������� �����������
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpInsert_bi_Table_Sale'
               -- ProtocolData
             , zfConvert_DateToString (inStartDate)
   || ' - ' || zfConvert_DateToString (inEndDate)
              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpinsert_bi_table_sale(tdatetime, tdatetime, tvarchar)
  OWNER TO project;
