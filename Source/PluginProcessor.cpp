#include "PluginProcessor.h"
#include "PluginEditor.h"

AuVstBridgeProcessor::AuVstBridgeProcessor()
    : AudioProcessor (BusesProperties()
                     .withInput  ("Input",  juce::AudioChannelSet::stereo(), true)
                     .withOutput ("Output", juce::AudioChannelSet::stereo(), true))
{
}

AuVstBridgeProcessor::~AuVstBridgeProcessor()
{
}

const juce::String AuVstBridgeProcessor::getName() const
{
    return JucePlugin_Name;
}

bool AuVstBridgeProcessor::acceptsMidi() const
{
    return false;
}

bool AuVstBridgeProcessor::producesMidi() const
{
    return false;
}

bool AuVstBridgeProcessor::isMidiEffect() const
{
    return false;
}

double AuVstBridgeProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int AuVstBridgeProcessor::getNumPrograms()
{
    return 1;
}

int AuVstBridgeProcessor::getCurrentProgram()
{
    return 0;
}

void AuVstBridgeProcessor::setCurrentProgram (int index)
{
}

const juce::String AuVstBridgeProcessor::getProgramName (int index)
{
    return {};
}

void AuVstBridgeProcessor::changeProgramName (int index, const juce::String& newName)
{
}

void AuVstBridgeProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
}

void AuVstBridgeProcessor::releaseResources()
{
}

void AuVstBridgeProcessor::processBlock (juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages)
{
    juce::ScopedNoDenormals noDenormals;
    auto totalNumInputChannels  = getTotalNumInputChannels();
    auto totalNumOutputChannels = getTotalNumOutputChannels();

    for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    for (int channel = 0; channel < totalNumInputChannels; ++channel)
    {
        auto* channelData = buffer.getWritePointer (channel);
        for (int sample = 0; sample < buffer.getNumSamples(); ++sample)
        {
            channelData[sample] = channelData[sample];  // Pass-through
        }
    }
}

bool AuVstBridgeProcessor::hasEditor() const
{
    return true;
}

juce::AudioProcessorEditor* AuVstBridgeProcessor::createEditor()
{
    return new juce::GenericAudioProcessorEditor (*this);
}

void AuVstBridgeProcessor::getStateInformation (juce::MemoryBlock& destData)
{
}

void AuVstBridgeProcessor::setStateInformation (const void* data, int sizeInBytes)
{
}

juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new AuVstBridgeProcessor();
} 