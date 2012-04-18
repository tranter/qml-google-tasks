import QtQuick 1.0

TaskToolButton
{
    border.color: "#2E2E2E"
    gradient: normalGradient

    Gradient {
        id: normalGradient
        GradientStop { position: 0.0; color: "#434343" }
        GradientStop { position: 0.5; color: "#191919" }
        GradientStop { position: 1.0; color: "#191919" }
    }
}
