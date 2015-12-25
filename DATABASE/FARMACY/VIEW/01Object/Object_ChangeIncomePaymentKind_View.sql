-- View: Object_ChangeIncomePaymentKind_View

DROP VIEW IF EXISTS Object_ChangeIncomePaymentKind_View CASCADE;

CREATE OR REPLACE VIEW Object_ChangeIncomePaymentKind_View AS
    SELECT 
        Object_ChangeIncomePaymentKind.Id          AS Id
      , Object_ChangeIncomePaymentKind.ValueData   AS Name
    FROM 
        Object AS Object_ChangeIncomePaymentKind
    WHERE 
        Object_ChangeIncomePaymentKind.DescId = zc_Object_ChangeIncomePaymentKind();

ALTER TABLE Object_ChangeIncomePaymentKind_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 10.12.15                                                          *
*/

-- ����
-- SELECT * FROM Object_ChangeIncomePaymentKind_View
