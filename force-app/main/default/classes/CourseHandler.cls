@RestResource(urlMapping = '/Course/*')
global with sharing class CourseHandler {
	@HttpGet
	global static void doGet() {

		List<Course__c> courses = [SELECT Id, Name, RegistrationUrl2__c, RegistrationFromDateTime__c, RegistrationToDateTime__c, RegistrationDeadline__c, RegistrationPlaceName__c, DescriptionFormatted__c, DescriptionShort__c, Active__c, Region__c, Type__c, Theme__c FROM Course__c];

		List<CourseApiModel> wrapperList = new List<CourseApiModel>();

		for ( Course__c course : courses ) {
			CourseApiModel wrapper = new CourseApiModel();

			wrapper.RegistrationID = course.Id;
			wrapper.Title = course.Name;
			wrapper.RegistrationUrl = course.RegistrationUrl2__c;
			wrapper.RegistrationFromDateTime = course.RegistrationFromDateTime__c;
			wrapper.RegistrationToDateTime = course.RegistrationToDateTime__c;
			wrapper.RegistrationDeadline = course.RegistrationDeadline__c;
			wrapper.FrontPageDescription = course.DescriptionFormatted__c;
			wrapper.Description = course.DescriptionShort__c;
			wrapper.ShowInActivityList = course.Active__c ? 1 : 0;

			wrapper.configurable_custom = new CourseApiModel.Configurable_custom();

			wrapper.configurable_custom.Fylke = course.Region__c;
			wrapper.configurable_custom.Type = course.Type__c;
			wrapper.configurable_custom.Tema = course.Theme__c;

			wrapperList.add( wrapper );
		}

		RestContext.response.addHeader( 'Content-Type', 'application/json' );
		RestContext.response.responseBody = Blob.valueOf( JSON.serialize( wrapperList ) );
	}
}