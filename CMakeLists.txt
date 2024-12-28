cmake_minimum_required(VERSION 3.15)

project(AU-VST-Bridge VERSION 1.0.0)

# VST3 SDK 빌드 옵션 설정
set(SMTG_ADD_VST3_HOSTING_SAMPLES OFF CACHE BOOL "Don't build VST3 hosting samples")
set(SMTG_ADD_VST3_PLUGINS_SAMPLES OFF CACHE BOOL "Don't build VST3 plugins samples")

# JUCE 서브모듈 추가
add_subdirectory(Dependencies/JUCE)

# VST3 SDK 서브모듈 추가
add_subdirectory(Dependencies/vst3sdk EXCLUDE_FROM_ALL)

# AU-VST-Bridge 플러그인 설정
juce_add_plugin(AU-VST-Bridge
    VERSION 1.0.0
    COMPANY_NAME "Seongho Bae"
    IS_SYNTH FALSE
    NEEDS_MIDI_INPUT FALSE
    NEEDS_MIDI_OUTPUT FALSE
    IS_MIDI_EFFECT FALSE
    EDITOR_WANTS_KEYBOARD_FOCUS FALSE
    COPY_PLUGIN_AFTER_BUILD FALSE
    PLUGIN_MANUFACTURER_CODE Sbae
    PLUGIN_CODE Auvb
    FORMATS AU VST3
    PRODUCT_NAME "AU-VST-Bridge")

# 소스 파일 추가
target_sources(AU-VST-Bridge
    PRIVATE
        Source/PluginProcessor.cpp
        Source/PluginEditor.cpp)

# 컴파일러 설정
target_compile_features(AU-VST-Bridge PRIVATE cxx_std_17)

# JUCE 모듈 설정
target_link_libraries(AU-VST-Bridge
    PRIVATE
        juce::juce_audio_utils
        juce::juce_audio_processors
        juce::juce_audio_plugin_client
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags) 