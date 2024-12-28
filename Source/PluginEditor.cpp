#include "PluginProcessor.h"
#include "PluginEditor.h"

AuVstBridgeEditor::AuVstBridgeEditor (AuVstBridgeProcessor& p)
    : AudioProcessorEditor (&p), processorRef (p)
{
    setSize (400, 300);
}

AuVstBridgeEditor::~AuVstBridgeEditor()
{
}

void AuVstBridgeEditor::paint (juce::Graphics& g)
{
    g.fillAll (getLookAndFeel().findColour (juce::ResizableWindow::backgroundColourId));

    g.setColour (juce::Colours::white);
    g.setFont (15.0f);
    g.drawFittedText ("AU-VST-Bridge", getLocalBounds(), juce::Justification::centred, 1);
}

void AuVstBridgeEditor::resized()
{
} 