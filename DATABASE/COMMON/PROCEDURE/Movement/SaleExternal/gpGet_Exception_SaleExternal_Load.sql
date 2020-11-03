-- Function: gpGet_Exception_SaleExternal_Load()

DROP FUNCTION IF EXISTS gpGet_Exception_SaleExternal_Load (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Exception_SaleExternal_Load(
    IN inRetailId              Integer   , --
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN
 
     -- ��������
     IF COALESCE (inRetailId,0) = 0
     THEN
         RAISE EXCEPTION '������.�������� ���� �� �������';
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
03.11.20          *
*/

-- ����
--