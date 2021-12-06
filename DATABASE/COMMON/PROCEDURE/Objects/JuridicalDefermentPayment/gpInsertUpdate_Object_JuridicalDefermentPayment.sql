-- Function: gpInsert_JuridicalDefermentPayment()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalDefermentPayment (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalDefermentPayment(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbStartDate1 TDateTime;--���. 1 ������ - 1 �����
   DECLARE vbStartDate2 TDateTime;--���. 2 ������ - 2 �����
   DECLARE vbStartDate3 TDateTime;--���. 3 ������ - 1 ���
   DECLARE vbStartDate4 TDateTime;--���. 4 ������ - ���.���� inStartDate
   DECLARE vbEndDate1 TDateTime;  --�����. 1 ������ - 1 ����� 
   DECLARE vbEndDate2 TDateTime;  --�����. 2 ������ -2 ����� �����
   DECLARE vbEndDate3 TDateTime;  --�����. 3 ������ -1 ��� �����
   DECLARE vbEndDate4 TDateTime;  --�����. 4 ������ -

   DECLARE vbUserId Integer;
BEGIN

   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� ������ ��� �� ����� ���������
   vbStartDate1 := DATE_TRUNC ('MONTH', inEndDate) - INTERVAL '1 MONTH';  
   vbEndDate1   := inEndDate;
   
   vbStartDate2 := CASE WHEN vbStartDate1 <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE vbStartDate1 - INTERVAL '2 MONTH' END;
   vbEndDate2   := CASE WHEN vbStartDate1 <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE vbStartDate1 - INTERVAL '1 DAY' END;
   
   vbStartDate3 := CASE WHEN vbStartDate1 - INTERVAL '2 MONTH' <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE vbStartDate2 - INTERVAL '1 YEAR' END;
   vbEndDate3   := CASE WHEN vbStartDate1 - INTERVAL '2 MONTH' <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE vbStartDate2 - INTERVAL '1 DAY' END;
   
   vbStartDate4 := CASE WHEN vbStartDate2 - INTERVAL '1 YEAR' <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE inStartDate END;
   vbEndDate4   := CASE WHEN vbStartDate2 - INTERVAL '1 YEAR' <= inStartDate THEN inEndDate + INTERVAL '1 DAY' ELSE vbStartDate3 - INTERVAL '1 DAY' END;   

 --RAISE EXCEPTION '������.�������� 1 c <%> �� <%>  /// 2 �  <%> �� <%> ///3 �  <%> �� <%> 4 �  <%> �� <%>.', vbStartDate1,vbEndDate1 , vbStartDate2,vbEndDate2, vbStartDate3,vbEndDate3, vbStartDate4,vbEndDate4;
  
  
  CREATE TEMP TABLE _tmpData (JuridicalId Integer, ContractId Integer, OperDate TDateTime, Amount TFloat) ON COMMIT DROP;
  INSERT INTO _tmpData (JuridicalId, ContractId, OperDate, Amount)
  WITH
    --����������
    tmpPost AS (SELECT lfSelect_Object_Juridical_byGroup.JuridicalId FROM lfSelect_Object_Juridical_byGroup (8357 ) AS lfSelect_Object_Juridical_byGroup)

   --�������� ��� ��.���� � ��������
  , tmpJuridical AS (SELECT tmpJuridical.JuridicalId
                          , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                          , tmpJuridical.isPost
                     FROM
                         (SELECT Object_Juridical.Id AS JuridicalId
                               , CASE WHEN tmpPost.JuridicalId IS NULL THEN FALSE ELSE TRUE END AS isPost -- ����������
                          FROM Object AS Object_Juridical
                               LEFT JOIN tmpPost ON tmpPost.JuridicalId = Object_Juridical.Id
                          WHERE Object_Juridical.DescId = zc_Object_Juridical()
                           AND Object_Juridical.isErased = FALSE
                           ) AS tmpJuridical
                         JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                         ON ObjectLink_Contract_Juridical.ChildObjectId = tmpJuridical.JuridicalId
                                        AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
                         -- ������ ���������
                         JOIN Object AS Object_Contract
                                     ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                    AND Object_Contract.isErased = FALSE
                         -- ������ ��������
                         LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                              ON ObjectLink_Contract_ContractStateKind.ObjectId      = ObjectLink_Contract_Juridical.ObjectId
                                             AND ObjectLink_Contract_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()
                                             AND ObjectLink_Contract_ContractStateKind.ChildObjectId = zc_Enum_ContractStateKind_Close()
                     -- ������ ��������
                     WHERE ObjectLink_Contract_ContractStateKind.ChildObjectId IS NULL
                     )


   --������� ��������� ������ �� 1 �����
   , tmpLastPayment1 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             --, tmp.AccountId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   --, Container.ObjectId     AS AccountId
                                   , CASE WHEN tmpJuridical.isPost = FALSE THEN (-1 * MIContainer.Amount) ELSE MIContainer.Amount END AS Amount 
                                   , MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId) AS OperDate_max
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                       
                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId, tmpJuridical.isPost
                                               FROM tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate1 AND vbEndDate1
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.OperDate = tmp.OperDate_max
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               --, tmp.AccountId
                        )
   -- �� ������� ��� ������ �� 1 ����� � tmpLastPayment1
   , tmpJuridical_2 AS (select tmpJuridical.* 
                        from tmpJuridical
                             LEFT JOIN tmpLastPayment1 ON tmpLastPayment1.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment1.ContractId = tmpJuridical.ContractId
                        WHERE tmpLastPayment1.JuridicalId IS NULL
                       )

   --������� ��������� ������ �� 2 ������ (
   , tmpLastPayment2 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             --, tmp.AccountId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   --, Container.ObjectId     AS AccountId
                                   , (-1 * MIContainer.Amount) AS Amount
                                   , MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId) AS OperDate_max
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                       
                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId
                                               FROM tmpJuridical_2 AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate2 AND vbEndDate2
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.OperDate = tmp.OperDate_max
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               --, tmp.AccountId
                        )
   -- �� ������� ��� ������ �� 3 ����� � tmpLastPayment1 � tmpLastPayment2
   , tmpJuridical_3 AS (SELECT tmpJuridical.* 
                        FROM tmpJuridical_2 AS tmpJuridical
                             LEFT JOIN tmpLastPayment2 ON tmpLastPayment2.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment2.ContractId = tmpJuridical.ContractId
                        WHERE tmpLastPayment2.JuridicalId IS NULL
                       )


---
   --������� ��������� ������ �� 12 ������� (
   , tmpLastPayment3 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             --, tmp.AccountId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   --, Container.ObjectId     AS AccountId
                                   , (-1 * MIContainer.Amount) AS Amount
                                   , MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId) AS OperDate_max
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                       
                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId
                                               FROM tmpJuridical_3 AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate3 AND vbEndDate3
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.OperDate = tmp.OperDate_max
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               --, tmp.AccountId
                        )
   -- �� ������� ��� ������ �� 12 ������� � tmpLastPayment1 � tmpLastPayment2
   , tmpJuridical_4 AS (select tmpJuridical.* 
                        from tmpJuridical_3 AS tmpJuridical
                             LEFT JOIN tmpLastPayment3 ON tmpLastPayment3.JuridicalId = tmpJuridical.JuridicalId
                                                      AND tmpLastPayment3.ContractId = tmpJuridical.ContractId
                        WHERE tmpLastPayment3.JuridicalId IS NULL
                       )

   --������� ��������� ������ �� 12 ������� (
   , tmpLastPayment4 AS (SELECT tmp.OperDate
                             , tmp.JuridicalId
                             , tmp.ContractId
                             --, tmp.AccountId
                             , SUM (tmp.Amount) AS Amount
                        FROM (SELECT MIContainer.OperDate
                                   , CLO_Juridical.ObjectId AS JuridicalId
                                   , CLO_Contract.ObjectId  AS ContractId
                                   --, Container.ObjectId     AS AccountId
                                   , (-1 * MIContainer.Amount) AS Amount
                                   , MAX (MIContainer.OperDate) OVER (PARTITION BY CLO_Juridical.ObjectId, CLO_Contract.ObjectId) AS OperDate_max
                              FROM ContainerLinkObject AS CLO_Juridical
                                   INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()

                                   INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                  ON CLO_Contract.ContainerId = Container.Id
                                                                 AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                       
                                   INNER JOIN (SELECT DISTINCT tmpJuridical.JuridicalId, tmpJuridical.ContractId
                                               FROM tmpJuridical_4 AS tmpJuridical) AS tmpJuridical 
                                                               ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                                              AND tmpJuridical.ContractId = CLO_Contract.ObjectId 

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id              --      
                                                                   AND MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_PersonalAccount())
                                                                   AND MIContainer.Amount <> 0
                                                                   AND MIContainer.OperDate BETWEEN vbStartDate4 AND vbEndDate4
                              WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                       --AND CLO_Juridical.ObjectId = 862910 
                              ) as tmp
                        WHERE tmp.OperDate = tmp.OperDate_max
                        GROUP BY tmp.OperDate
                               , tmp.JuridicalId
                               , tmp.ContractId
                               --, tmp.AccountId
                        )


     SELECT tmpJuridical.JuridicalId
          , tmpJuridical.ContractId
          , COALESCE (tmpLastPayment1.OperDate, tmpLastPayment2.OperDate, tmpLastPayment3.OperDate, tmpLastPayment4.OperDate) AS OperDate
          , COALESCE (tmpLastPayment1.Amount, tmpLastPayment2.Amount, tmpLastPayment3.Amount, tmpLastPayment4.Amount) AS Amount
     FROM tmpJuridical
          LEFT JOIN tmpLastPayment1 ON tmpLastPayment1.JuridicalId = tmpJuridical.JuridicalId
                                   AND tmpLastPayment1.ContractId = tmpJuridical.ContractId
          LEFT JOIN tmpLastPayment2 ON tmpLastPayment2.JuridicalId = tmpJuridical.JuridicalId
                                   AND tmpLastPayment2.ContractId = tmpJuridical.ContractId
          LEFT JOIN tmpLastPayment3 ON tmpLastPayment3.JuridicalId = tmpJuridical.JuridicalId
                                   AND tmpLastPayment3.ContractId = tmpJuridical.ContractId
          LEFT JOIN tmpLastPayment4 ON tmpLastPayment4.JuridicalId = tmpJuridical.JuridicalId
                                   AND tmpLastPayment4.ContractId = tmpJuridical.ContractId
     WHERE COALESCE (tmpLastPayment1.Amount, tmpLastPayment2.Amount, tmpLastPayment3.Amount, tmpLastPayment4.Amount) <> 0
     ;

 --����������� ������
 CREATE TEMP TABLE _tmpObject (Id Integer, JuridicalId Integer, ContractId Integer, OperDate TDateTime, Amount TFloat) ON COMMIT DROP;
  INSERT INTO _tmpObject (Id, JuridicalId, ContractId, OperDate, Amount)
  
  SELECT Object_JuridicalDefermentPayment.Id
       , ObjectLink_JuridicalDefermentPayment_Juridical.ChildObjectId AS JuridicalId
       , ObjectLink_JuridicalDefermentPayment_Contract.ChildObjectId  AS ContractId
       , ObjectDate_JuridicalDefermentPayment_OperDate.ValueData      AS OperDate
       , ObjectFloat_JuridicalDefermentPayment_Amount.ValueData       AS Amount
  FROM Object AS Object_JuridicalDefermentPayment
        LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_Juridical
                             ON ObjectLink_JuridicalDefermentPayment_Juridical.ObjectId = Object_JuridicalDefermentPayment.Id
                            AND ObjectLink_JuridicalDefermentPayment_Juridical.DescId = zc_ObjectLink_JuridicalDefermentPayment_Juridical()
  
        LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_Contract
                             ON ObjectLink_JuridicalDefermentPayment_Contract.ObjectId = Object_JuridicalDefermentPayment.Id
                            AND ObjectLink_JuridicalDefermentPayment_Contract.DescId = zc_ObjectLink_JuridicalDefermentPayment_Contract()
   
       LEFT JOIN ObjectDate AS ObjectDate_JuridicalDefermentPayment_OperDate
                            ON ObjectDate_JuridicalDefermentPayment_OperDate.ObjectId = Object_JuridicalDefermentPayment.Id
                           AND ObjectDate_JuridicalDefermentPayment_OperDate.DescId = zc_ObjectDate_JuridicalDefermentPayment_OperDate()

       LEFT JOIN ObjectFloat AS ObjectFloat_JuridicalDefermentPayment_Amount
                             ON ObjectFloat_JuridicalDefermentPayment_Amount.ObjectId = Object_JuridicalDefermentPayment.Id
                            AND ObjectFloat_JuridicalDefermentPayment_Amount.DescId = zc_ObjectFloat_JuridicalDefermentPayment_Amount()
  WHERE Object_JuridicalDefermentPayment.DescId = zc_Object_JuridicalDefermentPayment()
  ;

 --��������� � + ����� ������
 PERFORM lpInsertUpdate_Object_JuridicalDefermentPayment (inId          := COALESCE (_tmpObject.Id,0) ::Integer
                                                        , inJuridicalId := _tmpData.JuridicalId       ::Integer
                                                        , inContractId  := _tmpData.ContractId        ::Integer
                                                        , inOperDate    := _tmpData.OperDate          ::TDateTime
                                                        , inAmount      := _tmpData.Amount            ::TFloat
                                                        , inUserId      := vbUserId                   ::Integer
                                               )
 FROM _tmpData
      LEFT JOIN _tmpObject ON _tmpObject.JuridicalId = _tmpData.JuridicalId
                          AND _tmpObject.ContractId = _tmpData.ContractId
 ;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.12.21         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_JuridicalDefermentPayment (inStartDate:= '11.05.2021', inEndDate:= CURRENT_DATE, inSession:= '9457');