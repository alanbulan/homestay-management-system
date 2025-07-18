package com.hms.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.text.SimpleDateFormat;

/**
 * Jackson配置类
 * 配置JSON序列化和反序列化
 */
@Configuration
public class JacksonConfig {

    /**
     * 配置ObjectMapper Bean
     * 支持Java 8时间类型
     */
    @Bean
    @Primary
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        
        // 注册JSR310模块支持Java 8时间类型
        mapper.registerModule(new JavaTimeModule());
        
        // 设置日期格式
        mapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"));
        
        // 禁用将日期写为时间戳
        mapper.disable(com.fasterxml.jackson.databind.SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        
        return mapper;
    }
}
