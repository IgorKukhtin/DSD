-- Function: gpInsertUpdate_Object_OrderShedule()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderShedule (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderShedule(
 INOUT ioId                       Integer ,    -- ���� ������� <������ ������/��������>
    IN inCode                     Integer ,    -- ��� ������� <>
    IN inValue1                   TVarChar  ,  -- ���������� ��������
    IN inValue2                   TVarChar  ,  -- �������
    IN inValue3                   TVarChar  ,  -- �����
    IN inValue4                   TVarChar  ,  -- �������
    IN inValue5                   TVarChar  ,  -- �������
    IN inValue6                   TVarChar  ,  -- �������
    IN inValue7                   TVarChar  ,  -- �����������
   OUT outInf_Text1               TVarChar  ,  -- ���. �������� ���� ������ �����
   OUT outInf_Text2               TVarChar  ,  -- ���. �������� ���� ������ ��������
   OUT outColor_Calc1             Integer   ,  -- ���� �����������
   OUT outColor_Calc2             Integer   ,  -- ���� �������
   OUT outColor_Calc3             Integer   ,  -- ���� �����
   OUT outColor_Calc4             Integer   ,  -- ���� �������
   OUT outColor_Calc5             Integer   ,  -- ���� �������
   OUT outColor_Calc6             Integer   ,  -- ���� �������
   OUT outColor_Calc7             Integer   ,  -- ���� �����������
    IN inUnitId                   Integer   ,  -- ������ �������������
    IN inContractId               Integer   ,  -- ������ �� �������
    IN inSession                  TVarChar     -- ������ ������������
)
  RETURNS record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
   DECLARE vbName TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderShedule());
   vbUserId:= inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_OrderShedule());
    
    -- �������� ������������  �� ������� � �������������
    IF COALESCE (ioId,0) = 0 THEN
       IF EXISTS (SELECT ObjectLink_OrderShedule_Contract.ObjectId
                  FROM ObjectLink AS ObjectLink_OrderShedule_Contract
                     INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                             ON ObjectLink_OrderShedule_Unit.ObjectId = ObjectLink_OrderShedule_Contract.ObjectId
                            AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                            AND ObjectLink_OrderShedule_Unit.ChildObjectId = inUnitId
                  WHERE ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                    AND ObjectLink_OrderShedule_Contract.ChildObjectId = inContractId
                  ) 
       THEN
          RAISE EXCEPTION '������ �� ��������� - ������ = "%" ������� "%" .',  lfGet_Object_ValueData(inUnitId), lfGet_Object_ValueData(inContractId);
       END IF;
    END IF;
 
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_OrderShedule(), vbCode_calc);

   vbName:= (inValue1||';'||inValue2||';'||inValue3||';'||inValue4||';'||inValue5||';'||inValue6||';'||inValue7) :: TVarChar;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderShedule(), vbCode_calc, vbName);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderShedule_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderShedule_Unit(), ioId, inUnitId);

 -- ���. �������� ���� ������ �����
 outInf_Text1:= (CASE WHEN CAST('0'||inValue1 AS TFloat) in (1,3) THEN '�����������,' ELSE '' END ||
                 CASE WHEN CAST('0'||inValue2 AS TFloat) in (1,3) THEN '�������,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue3 AS TFloat) in (1,3) THEN '�����,'       ELSE '' END ||
                 CASE WHEN CAST('0'||inValue4 AS TFloat) in (1,3) THEN '�������,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue5 AS TFloat) in (1,3) THEN '�������,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue6 AS TFloat) in (1,3) THEN '�������,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue7 AS TFloat) in (1,3) THEN '�����������'  ELSE '' END) ::TVarChar;
 -- ���. �������� ���� ������ ��������
 outInf_Text2:= (CASE WHEN CAST('0'||inValue1 AS TFloat) in (2,3) THEN '�����������,' ELSE '' END ||
                 CASE WHEN CAST('0'||inValue2 AS TFloat) in (2,3) THEN '�������,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue3 AS TFloat) in (2,3) THEN '�����,'       ELSE '' END ||
                 CASE WHEN CAST('0'||inValue4 AS TFloat) in (2,3) THEN '�������,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue5 AS TFloat) in (2,3) THEN '�������,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue6 AS TFloat) in (2,3) THEN '�������,'     ELSE '' END ||
                 CASE WHEN CAST('0'||inValue7 AS TFloat) in (2,3) THEN '�����������'  ELSE '' END) ::TVarChar;

 -- ���������� ����             
 outColor_Calc1:= CASE WHEN CAST('0'||inValue1 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue1 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue1 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc2:= CASE WHEN CAST('0'||inValue2 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue2 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue2 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc3:= CASE WHEN CAST('0'||inValue3 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue3 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue3 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc4:= CASE WHEN CAST('0'||inValue4 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue4 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue4 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc5:= CASE WHEN CAST('0'||inValue5 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue5 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue5 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc6:= CASE WHEN CAST('0'||inValue6 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue6 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue6 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;
 outColor_Calc7:= CASE WHEN CAST('0'||inValue7 AS TFloat) = 1 THEN zc_Color_Yelow() WHEN CAST('0'||inValue7 AS TFloat) = 2 THEN zc_Color_Aqua() WHEN CAST('0'||inValue7 AS TFloat) = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.10.16         * parce
 20.09.16         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_OrderShedule ()                            
