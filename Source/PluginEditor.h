#pragma once

#include "PluginProcessor.h"
#include <juce_audio_processors/juce_audio_processors.h>
#include <juce_gui_basics/juce_gui_basics.h>

class AuVstBridgeEditor : public juce::AudioProcessorEditor
{
public:
    explicit AuVstBridgeEditor (AuVstBridgeProcessor&);
    ~AuVstBridgeEditor() override;

    void paint (juce::Graphics&) override;
    void resized() override;

private:
    AuVstBridgeProcessor& processorRef;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (AuVstBridgeEditor)
}; 