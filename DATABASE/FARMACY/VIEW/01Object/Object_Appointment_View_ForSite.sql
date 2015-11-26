-- View: Object_Appointment_View_ForSite

DROP VIEW IF EXISTS Object_Appointment_View_ForSite;

CREATE OR REPLACE VIEW Object_Appointment_View_ForSite AS
    SELECT 
        Object_Appointment.Id                  as id
       ,Object_Appointment.ObjectCode::Integer as code
       ,Object_Appointment.ValueData           as name
       ,Object_Appointment.isErased                  as deleted
    FROM Object AS Object_Appointment
    WHERE
        Object_Appointment.DescId = zc_Object_Appointment();
       
ALTER TABLE Object_Appointment_View_ForSite  OWNER TO postgres;
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 26.11.15                                                          *
*/

--Select * from Object_Appointment_View_ForSite as Object_GoodsAvailability