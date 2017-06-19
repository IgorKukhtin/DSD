-- Function: gpUpdate_Object_Price_MCSAuto (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Price_MCSAuto (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Price_MCSAuto(
    IN inMCSValue                 TFloat    ,    -- ����������� �������� �����
    IN inGoodsId                  Integer   ,    -- �����
    IN inDays                     TFloat    ,    -- ���-�� ���� ������� ���

   OUT outMCSValueOld             TFloat    ,    -- ��� - �������� ������� �������� �� ��������� �������
   OUT outStartDateMCSAuto        TDateTime ,    -- ���� ���. �������� ��� (����)
   OUT outEndDateMCSAuto          TDateTime ,    -- ���� �����. �������� ��� (����)
   OUT outIsMCSNotRecalc          Boolean   ,    -- ������������ ���� - ���������� ��������
   OUT outIsMCSNotRecalcOld       Boolean   ,    -- ������������ ���� - �������� ������� �������� �� ��������� �������
   OUT outIsMCSAuto               Boolean   ,    -- ����� - ��� �� ������

    IN inSession                  TVarChar       -- ������ ������������
)
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbUnitId  Integer;
    DECLARE vbPriceId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;


    -- ����� UnitId
    vbUnitId:= COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '0') :: Integer;

    
    -- ����� ������� ����
    vbPriceId:= (SELECT ObjectLink_Price_Unit.ObjectId AS Id
                 FROM ObjectLink AS ObjectLink_Price_Unit
                      INNER JOIN ObjectLink AS Price_Goods
                                            ON Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                                           AND Price_Goods.DescId        =  zc_ObjectLink_Price_Goods()
                                           AND Price_Goods.ChildObjectId = inGoodsId
                 WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                );
    
    
    
    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (vbPriceId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 19.06.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Price_MCSAuto()
