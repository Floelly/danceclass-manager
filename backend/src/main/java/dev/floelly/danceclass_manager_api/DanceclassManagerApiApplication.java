package dev.floelly.danceclass_manager_api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.filter.CommonsRequestLoggingFilter;

@SpringBootApplication
public class DanceclassManagerApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(DanceclassManagerApiApplication.class, args);
	}

	@Bean
	public CommonsRequestLoggingFilter requestLoggingFilter() {
		CommonsRequestLoggingFilter loggingFilter = new CommonsRequestLoggingFilter();
		loggingFilter.setIncludeClientInfo(true);
		loggingFilter.setIncludeQueryString(true);
		loggingFilter.setIncludePayload(true);
		loggingFilter.setMaxPayloadLength(10000);
		loggingFilter.setIncludeHeaders(true);
		loggingFilter.setAfterMessagePrefix("REQUEST DATA : ");
		return loggingFilter;
	}

}
