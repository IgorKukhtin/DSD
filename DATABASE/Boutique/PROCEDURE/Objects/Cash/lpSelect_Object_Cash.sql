-- Function: lpSelect_Object_Cash()

DROP FUNCTION IF EXISTS lpSelect_Object_Cash (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Object_Cash(
    IN inUnitId                Integer   , -- ����
    IN inUserId                Integer     -- ����
)
RETURNS TABLE (CashId         Integer
             , CashCode       Integer
             , CashName       TVarChar
             , CurrencyId     Integer
             , CurrencyCode   Integer
             , CurrencyName   TVarChar
             , UnitId         Integer
             , UnitCode       Integer
             , UnitName       TVarChar
             , isBankAccount  Boolean
              )
AS
$BODY$
BEGIN

     -- ���� - ������, ��� � ����� ���������
     CREATE TEMP TABLE _tmpCash_list (CashId Integer, CashCode Integer, CashName TVarChar, CurrencyId Integer, CurrencyCode Integer, CurrencyName TVarChar, UnitId Integer, UnitCode Integer, UnitName TVarChar, isBankAccount Boolean) ON COMMIT DROP;

     -- ������������ ������
     INSERT INTO _tmpCash_list (CashId, CashCode, CashName, CurrencyId, CurrencyCode, CurrencyName, UnitId, UnitCode, UnitName, isBankAccount)
       SELECT Object_Cash.Id                  AS CashId
            , Object_Cash.ObjectCode          AS CashCode
            , Object_Cash.ValueData           AS CashName
            , Object_Currency.Id              AS CurrencyId
            , Object_Currency.ObjectCode      AS CurrencyCode
            , Object_Currency.ValueData       AS CurrencyName
            , Object_Unit.Id                  AS UnitId
            , Object_Unit.ObjectCode          AS UnitCode
            , Object_Unit.ValueData           AS UnitName
            , FALSE                           AS isBankAccount
       FROM Object AS Object_Unit
            -- ���� ����� �������� �� ��������
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                 ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
            -- ����� ��������� ����� ����� ������ �������������
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId    = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId      = zc_ObjectLink_Unit_Parent()
                                AND ObjectLink_Cash_Unit.ChildObjectId IS NULL
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                 ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
            -- ����� ��� �����
            LEFT JOIN Object AS Object_Cash
                             ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                            AND Object_Cash.DescId   = zc_Object_Cash()
                            AND Object_Cash.isErased = FALSE
            -- ������
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                                 ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                                AND ObjectLink_Cash_Currency.DescId   = zc_ObjectLink_Cash_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Cash_Currency.ChildObjectId

       WHERE Object_Unit.Id = inUnitId

      UNION ALL
       -- ��������� ���� �������� - � ���
       SELECT Object_BankAccount.Id           AS CashId
            , Object_BankAccount.ObjectCode   AS CashCode
            , Object_BankAccount.ValueData    AS CashName
            , Object_Currency.Id              AS CurrencyId
            , Object_Currency.ObjectCode      AS CurrencyCode
            , Object_Currency.ValueData       AS CurrencyName
            , Object_Unit.Id                  AS UnitId
            , Object_Unit.ObjectCode          AS UnitCode
            , Object_Unit.ValueData           AS UnitName
            , TRUE                           AS isBankAccount
       FROM ObjectLink AS ObjectLink_Unit_BankAccount
            INNER JOIN ObjectLink AS ObjectLink_BankAccount_Currency
                                  ON ObjectLink_BankAccount_Currency.ObjectId      = ObjectLink_Unit_BankAccount.ChildObjectId
                                 AND ObjectLink_BankAccount_Currency.DescId        = zc_ObjectLink_BankAccount_Currency()
                                 AND ObjectLink_BankAccount_Currency.ChildObjectId = zc_Currency_GRN()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ChildObjectId = ObjectLink_Unit_BankAccount.ObjectId
                                AND ObjectLink_Unit_Parent.DescId        = zc_ObjectLink_Unit_Parent()

           LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Unit_BankAccount.ChildObjectId
           LEFT JOIN Object AS Object_Currency    ON Object_Currency.Id    = ObjectLink_BankAccount_Currency.ChildObjectId
           LEFT JOIN Object AS Object_Unit        ON Object_Unit.Id        = inUnitId


       WHERE ObjectLink_Unit_BankAccount.DescId    = zc_ObjectLink_Unit_BankAccount()
         -- �.�. - ����� ������ �������
         AND (ObjectLink_Unit_BankAccount.ObjectId = inUnitId OR ObjectLink_Unit_Parent.ObjectId = inUnitId)
      ;


     -- �������� - CurrencyId ������ ���� ����������
     IF EXISTS (SELECT 1 FROM _tmpCash_list GROUP BY _tmpCash_list.CurrencyId, _tmpCash_list.isBankAccount HAVING COUNT(*) > 1) THEN
        RAISE EXCEPTION '������.��� �������� <%> ����������� ��������� ����/�.��. � ������ <%><%>.'
                       , lfGet_Object_ValueData (inUnitId)
                       , lfGet_Object_ValueData ((SELECT _tmpCash_list.CurrencyId FROM _tmpCash_list GROUP BY _tmpCash_list.CurrencyId, _tmpCash_list.isBankAccount HAVING COUNT(*) > 1 ORDER BY _tmpCash_list.CurrencyId, _tmpCash_list.isBankAccount LIMIT 1))
                       , (SELECT _tmpCash_list.isBankAccount FROM _tmpCash_list GROUP BY _tmpCash_list.CurrencyId, _tmpCash_list.isBankAccount HAVING COUNT(*) > 1 ORDER BY _tmpCash_list.CurrencyId, _tmpCash_list.isBankAccount LIMIT 1)
                        ;
     END IF;

     -- !!!��� SYBASE - ����� ������!!!
     IF inUserId = zc_User_Sybase() AND NOT EXISTS (SELECT 1 FROM _tmpCash_list)
     THEN
          -- !!!��� SYBASE - ����� ������!!!
          IF 1=0 THEN RAISE EXCEPTION '������.� �������� <%> �� ���������� ����� � ������ <%>.', lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (zc_Currency_GRN());
          END IF;
     ELSE

     -- �������� - ������ ���� zc_Currency_GRN - ���
     IF NOT EXISTS (SELECT 1 FROM _tmpCash_list WHERE _tmpCash_list.CurrencyId = zc_Currency_GRN() AND _tmpCash_list.isBankAccount = FALSE) THEN
        RAISE EXCEPTION '������.� �������� <%> �� ���������� ����� � ������ <%> (%).', lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (zc_Currency_GRN()), (SELECT COUNT(*) FROM _tmpCash_list);
     END IF;
     -- �������� - ������ ���� zc_Currency_EUR
     IF NOT EXISTS (SELECT 1 FROM _tmpCash_list WHERE _tmpCash_list.CurrencyId = zc_Currency_EUR() AND _tmpCash_list.isBankAccount = FALSE) THEN
        RAISE EXCEPTION '������.� �������� <%> �� ���������� ����� � ������ <%>.', lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (zc_Currency_EUR());
     END IF;
     -- �������� - ������ ���� zc_Currency_USD
     IF NOT EXISTS (SELECT 1 FROM _tmpCash_list WHERE _tmpCash_list.CurrencyId = zc_Currency_USD() AND _tmpCash_list.isBankAccount = FALSE) THEN
        RAISE EXCEPTION '������.� �������� <%> �� ���������� ����� � ������ <%>.', lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (zc_Currency_USD());
     END IF;
     -- �������� - ������ ���� zc_Currency_GRN - ��
     IF NOT EXISTS (SELECT 1 FROM _tmpCash_list WHERE _tmpCash_list.CurrencyId = zc_Currency_GRN() AND _tmpCash_list.isBankAccount = TRUE) THEN
        RAISE EXCEPTION '������.� �������� <%> �� ��������� �.���� � ������ <%>.', lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (zc_Currency_GRN());
     END IF;
     -- �������� - ������ ���� 3+1
     IF 4 <> (SELECT COUNT(*) FROM _tmpCash_list) THEN
        RAISE EXCEPTION '������.� �������� <%> �� ���������� ��� 3 ����� + 1 �.���� = <%>.', lfGet_Object_ValueData (inUnitId), (SELECT COUNT(*) FROM _tmpCash_list);
     END IF;

     END IF;


     -- ��������� - ���� ��� ����� �������� + �� �/��
     RETURN QUERY
       SELECT _tmpCash_list.CashId
            , _tmpCash_list.CashCode
            , _tmpCash_list.CashName
            , _tmpCash_list.CurrencyId
            , _tmpCash_list.CurrencyCode
            , _tmpCash_list.CurrencyName
            , _tmpCash_list.UnitId
            , _tmpCash_list.UnitCode
            , _tmpCash_list.UnitName
            , _tmpCash_list.isBankAccount
       FROM _tmpCash_list
      ;
                      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.05.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Unit (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM lpSelect_Object_Cash (inUnitId:= 6332, inUserId:= zfCalc_UserAdmin() :: Integer);
