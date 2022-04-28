-- Function: gpUpdate_Object_Juridical_Params()

--DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_Params (Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_Params (Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_Params (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_Params(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������� ����>
    IN inJuridicalGroupId    Integer   ,    -- ������ ����������� ���
    IN inRetailId            Integer   ,    -- �������� ����    
    IN inRetailReportId      Integer   ,    -- �������� ����(�����)  
    IN inBasisCode           Integer   ,    -- ��� ����
    IN inSummOrderMin        TFloat    ,    -- ����������� ����� � ������ >= 
    IN inSession             TVarChar       -- ������� ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbJuridicalGroupId Integer;
   DECLARE vbRetailId         Integer;
   DECLARE vbRetailReportId   Integer;
   DECLARE vbBasisCode        Integer;
   DECLARE vbSummOrderMin     TFloat;
BEGIN


   --������ �����
   vbJuridicalGroupId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Juridical_JuridicalGroup()) ::Integer;
   vbRetailReportId   := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Juridical_RetailReport()) ::Integer;
   vbRetailId         := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_Juridical_Retail()) ::Integer;
   vbSummOrderMin     := (SELECT ObjectFloat.ValueData    FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Juridical_SummOrderMin()) ::TFloat;
   --
   vbBasisCode        := (SELECT ObjectFloat.ValueData    FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_ObjectCode_Basis()) ::Integer;
                     
   IF COALESCE (vbJuridicalGroupId,0) <> COALESCE (inJuridicalGroupId,0)
   OR COALESCE (vbRetailReportId,0) <> COALESCE (inRetailReportId,0)
   OR COALESCE (vbRetailId,0) <> COALESCE (inRetailId,0)
   OR COALESCE (vbSummOrderMin,0) <> COALESCE (inSummOrderMin,0)
   THEN
       -- �������� ���� ������������ �� ����� ���������
       vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_Params());
    
        -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_JuridicalGroup(), ioId, inJuridicalGroupId);
    
        -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), ioId, inRetailId);
        -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_RetailReport(), ioId, inRetailReportId);
    
    
       -- ���� ��������� �����. SummOrderMin �������� ����
       IF COALESCE ((SELECT ObjectFloat_SummOrderMin.ValueData
                     FROM ObjectFloat AS ObjectFloat_SummOrderMin
                     WHERE ObjectFloat_SummOrderMin.ObjectId = ioId
                       AND ObjectFloat_SummOrderMin.DescId = zc_ObjectFloat_Juridical_SummOrderMin()),0) <> inSummOrderMin
       THEN
           vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_SummOrderMin());
    
           -- ��������� �������� <>
           PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_SummOrderMin(), ioId, inSummOrderMin);
       END IF;
   END IF;
   
   --
   IF vbBasisCode <> inBasisCode
   THEN
        -- �������� ���� ������������ �� ����� ���������
        vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectCode_Basis());
   
        -- ��������� ��������
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ObjectCode_Basis(), ioId, inBasisCode);   
   END IF;
   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Object_Juridical_Params  (Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.04.22         *
 28.04.21         * 
 20.10.21         * inSummOrderMin
 22.06.15                                        * all
 20.11.14         *
 07.11.14         * RetailReport ��������
 27.10.14                                        * add inJuridicalGroupId
 25.05.14                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Juridical_Params()
