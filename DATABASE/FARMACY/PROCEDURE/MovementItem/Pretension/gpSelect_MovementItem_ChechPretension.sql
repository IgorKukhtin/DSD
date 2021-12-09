-- Function: gpSelect_MovementItem_ChechPretension()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ChechPretension (Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ChechPretension(
    IN inGoodsCode              Integer   , -- ���� ���������
    IN inGoodsName              TVarChar  , --
    IN inReasonDifferencesName  TVarChar  , --
    IN inAmount                 TFloat    , --
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    
    IF COALESCE (inReasonDifferencesName, '') <> '' AND COALESCE (inAmount, 0) = 0
    THEN
      RAISE EXCEPTION '������. ��� ������ <%>  <%> � �������� ����������� <%> �� ��������� "���-�� �� ���������"', inGoodsCode, inGoodsName, inReasonDifferencesName;
    END IF;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.12.21                                                       *
 
*/

-- ����

select * from gpSelect_MovementItem_ChechPretension(inGoodsCode := 30451 , inGoodsName := '�������� ������� 30� (������������)' , inReasonDifferencesName := '�������' , inAmount := 5 ,  inSession := '3');