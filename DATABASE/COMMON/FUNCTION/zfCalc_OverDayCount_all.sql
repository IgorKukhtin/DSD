-- Function: zfCalc_OverDayCount_all (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS zfCalc_OverDayCount_all (Integer, Integer, Integer, TFloat, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_OverDayCount_all (
    IN inPartnerId    Integer,
    IN inContractId   Integer, -- здесь "главный"
    IN inPaidKindId   Integer,
    IN inOverSum      TFloat,
    IN inDate TDateTime
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAmount TFloat;
   DECLARE vbRec RECORD;
   DECLARE vbOverDayCount Integer := 0;
BEGIN
      vbAmount:= COALESCE (inOverSum, 0.0)::TFloat;

      /*IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpContainer_OverDayCount')
      THEN
          -- таблица - список Container
          CREATE TEMP TABLE _tmpContainer_OverDayCount (ContainerId Integer) ON COMMIT DROP;
      END IF;

      ANALYZE _tmpContainer_OverDayCount;*/

      IF vbAmount > 0.0
      THEN
           -- очистили
           /*DELETE FROM _tmpContainer_OverDayCount;
           -- создали нужный список
           INSERT INTO _tmpContainer_OverDayCount (ContainerId)
              WITH tmpContract_Key AS (SELECT -- это все ContractId
                                              COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                                       FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                                            LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                                       WHERE View_Contract_ContractKey.ContractId_Key = inContractId
                                      )
              SELECT Container_Summ.Id
              FROM Container AS Container_Summ
                   JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                   ON ObjectLink_Account_AccountGroup.ObjectId      = Container_Summ.ObjectId
                                  AND ObjectLink_Account_AccountGroup.DescId        = zc_ObjectLink_Account_AccountGroup()
                                  AND ObjectLink_Account_AccountGroup.ChildObjectId = zc_Enum_AccountGroup_30000() -- !!!ограничение - только Дебиторы!!!
                   JOIN ContainerLinkObject AS CLO_Partner
                                            ON CLO_Partner.ContainerId = Container_Summ.Id
                                           AND CLO_Partner.DescId      = zc_ContainerLinkObject_Partner()
                                           AND CLO_Partner.ObjectId    = inPartnerId
                   JOIN ContainerLinkObject AS CLO_Contract
                                            ON CLO_Contract.ContainerId = Container_Summ.Id
                                           AND CLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                   JOIN tmpContract_Key ON tmpContract_Key.ContractId = CLO_Contract.ObjectId
                   JOIN ContainerLinkObject AS CLO_PaidKind
                                            ON CLO_PaidKind.ContainerId = Container_Summ.Id
                                           AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                           AND CLO_PaidKind.ObjectId    = inPaidKindId
              ;*/

           -- Первый период
           FOR vbRec IN
              WITH tmpContract_Key AS (SELECT -- это все ContractId
                                              COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                                       FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                                            LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                                       WHERE View_Contract_ContractKey.ContractId_Key = inContractId
                                      )
      , _tmpContainer_OverDayCount AS (SELECT Container_Summ.Id AS ContainerId
                                       FROM Container AS Container_Summ
                                            JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                                            ON ObjectLink_Account_AccountGroup.ObjectId      = Container_Summ.ObjectId
                                                           AND ObjectLink_Account_AccountGroup.DescId        = zc_ObjectLink_Account_AccountGroup()
                                                           AND ObjectLink_Account_AccountGroup.ChildObjectId = zc_Enum_AccountGroup_30000() -- !!!ограничение - только Дебиторы!!!
                                            JOIN ContainerLinkObject AS CLO_Partner
                                                                     ON CLO_Partner.ContainerId = Container_Summ.Id
                                                                    AND CLO_Partner.DescId      = zc_ContainerLinkObject_Partner()
                                                                    AND CLO_Partner.ObjectId    = inPartnerId
                                            JOIN ContainerLinkObject AS CLO_Contract
                                                                     ON CLO_Contract.ContainerId = Container_Summ.Id
                                                                    AND CLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                                            JOIN tmpContract_Key ON tmpContract_Key.ContractId = CLO_Contract.ObjectId
                                            JOIN ContainerLinkObject AS CLO_PaidKind
                                                                     ON CLO_PaidKind.ContainerId = Container_Summ.Id
                                                                    AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                                                    AND CLO_PaidKind.ObjectId    = inPaidKindId
                                      )
               SELECT OperDate
                    , SUM (Amount)::TFloat AS Amount
               FROM MovementItemContainer
               WHERE ContainerId IN (SELECT DISTINCT _tmpContainer_OverDayCount.ContainerId FROM _tmpContainer_OverDayCount)
                 AND (MovementDescId = zc_Movement_Sale()
                  OR (MovementDescId = zc_Movement_TransferDebtOut() AND isActive))
                 AND OperDate BETWEEN inDate - INTERVAL '30 DAY' AND inDate
               GROUP BY OperDate
               ORDER BY OperDate DESC
           LOOP
                vbAmount:= vbAmount - vbRec.Amount;

                IF vbAmount <= 0.0
                THEN
                     vbOverDayCount:= DATE_PART ('day', inDate - vbRec.OperDate)::Integer + 1;

                     RETURN vbOverDayCount;
                END IF;
           END LOOP;

           -- Второй период
           IF vbAmount > 0.0
           THEN
               FOR vbRec IN
              WITH tmpContract_Key AS (SELECT -- это все ContractId
                                              COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                                       FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                                            LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                                       WHERE View_Contract_ContractKey.ContractId_Key = inContractId
                                      )
      , _tmpContainer_OverDayCount AS (SELECT Container_Summ.Id AS ContainerId
                                       FROM Container AS Container_Summ
                                            JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                                            ON ObjectLink_Account_AccountGroup.ObjectId      = Container_Summ.ObjectId
                                                           AND ObjectLink_Account_AccountGroup.DescId        = zc_ObjectLink_Account_AccountGroup()
                                                           AND ObjectLink_Account_AccountGroup.ChildObjectId = zc_Enum_AccountGroup_30000() -- !!!ограничение - только Дебиторы!!!
                                            JOIN ContainerLinkObject AS CLO_Partner
                                                                     ON CLO_Partner.ContainerId = Container_Summ.Id
                                                                    AND CLO_Partner.DescId      = zc_ContainerLinkObject_Partner()
                                                                    AND CLO_Partner.ObjectId    = inPartnerId
                                            JOIN ContainerLinkObject AS CLO_Contract
                                                                     ON CLO_Contract.ContainerId = Container_Summ.Id
                                                                    AND CLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                                            JOIN tmpContract_Key ON tmpContract_Key.ContractId = CLO_Contract.ObjectId
                                            JOIN ContainerLinkObject AS CLO_PaidKind
                                                                     ON CLO_PaidKind.ContainerId = Container_Summ.Id
                                                                    AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                                                    AND CLO_PaidKind.ObjectId    = inPaidKindId
                                      )
                   SELECT OperDate
                        , SUM (Amount)::TFloat AS Amount
                   FROM MovementItemContainer
                   WHERE ContainerId IN (SELECT DISTINCT _tmpContainer_OverDayCount.ContainerId FROM _tmpContainer_OverDayCount)
                     AND (MovementDescId = zc_Movement_Sale()
                      OR (MovementDescId = zc_Movement_TransferDebtOut() AND isActive))
                     AND OperDate BETWEEN inDate - INTERVAL '80 DAY' AND inDate - INTERVAL '31 DAY'
                   GROUP BY OperDate
                   ORDER BY OperDate DESC
               LOOP
                    vbAmount:= vbAmount - vbRec.Amount;

                    IF vbAmount <= 0.0
                    THEN
                         vbOverDayCount:= DATE_PART ('day', inDate - vbRec.OperDate)::Integer + 1;

                         RETURN vbOverDayCount;
                    END IF;
               END LOOP;
           END IF;

           -- Третий период
           IF vbAmount > 0.0
           THEN
               FOR vbRec IN
              WITH tmpContract_Key AS (SELECT -- это все ContractId
                                              COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                                       FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                                            LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                                       WHERE View_Contract_ContractKey.ContractId_Key = inContractId
                                      )
      , _tmpContainer_OverDayCount AS (SELECT Container_Summ.Id AS ContainerId
                                       FROM Container AS Container_Summ
                                            JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                                            ON ObjectLink_Account_AccountGroup.ObjectId      = Container_Summ.ObjectId
                                                           AND ObjectLink_Account_AccountGroup.DescId        = zc_ObjectLink_Account_AccountGroup()
                                                           AND ObjectLink_Account_AccountGroup.ChildObjectId = zc_Enum_AccountGroup_30000() -- !!!ограничение - только Дебиторы!!!
                                            JOIN ContainerLinkObject AS CLO_Partner
                                                                     ON CLO_Partner.ContainerId = Container_Summ.Id
                                                                    AND CLO_Partner.DescId      = zc_ContainerLinkObject_Partner()
                                                                    AND CLO_Partner.ObjectId    = inPartnerId
                                            JOIN ContainerLinkObject AS CLO_Contract
                                                                     ON CLO_Contract.ContainerId = Container_Summ.Id
                                                                    AND CLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                                            JOIN tmpContract_Key ON tmpContract_Key.ContractId = CLO_Contract.ObjectId
                                            JOIN ContainerLinkObject AS CLO_PaidKind
                                                                     ON CLO_PaidKind.ContainerId = Container_Summ.Id
                                                                    AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                                                    AND CLO_PaidKind.ObjectId    = inPaidKindId
                                      )
                   SELECT OperDate
                        , SUM (Amount)::TFloat AS Amount
                   FROM MovementItemContainer
                   WHERE ContainerId IN (SELECT DISTINCT _tmpContainer_OverDayCount.ContainerId FROM _tmpContainer_OverDayCount)
                     AND (MovementDescId = zc_Movement_Sale()
                      OR (MovementDescId = zc_Movement_TransferDebtOut() AND isActive))
                     AND OperDate BETWEEN inDate - INTERVAL '180 DAY' AND inDate - INTERVAL '81 DAY'
                   GROUP BY OperDate
                   ORDER BY OperDate DESC
               LOOP
                    vbAmount:= vbAmount - vbRec.Amount;

                    IF vbAmount <= 0.0
                    THEN
                         vbOverDayCount:= DATE_PART ('day', inDate - vbRec.OperDate)::Integer + 1;

                         RETURN vbOverDayCount;
                    END IF;
               END LOOP;
           END IF;


           -- Последний
           IF vbAmount > 0.0
           THEN
               -- пусть пока будет эта константа
               vbOverDayCount:= 181;

           END IF;

      END IF;

      RETURN vbOverDayCount;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.02.22                                        *
*/

-- тест
-- SELECT * FROM zfCalc_OverDayCount_all (inPartnerId:= 4099061, inContractId:= 6061519, inPaidKindId:= zc_Enum_PaidKind_SecondForm(), inOverSum:= 4953, inDate:= CURRENT_DATE)
