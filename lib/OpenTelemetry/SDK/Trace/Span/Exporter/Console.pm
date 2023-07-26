use Object::Pad;
# ABSTRACT: An OpenTelemetry span exporter that prints to the console

package OpenTelemetry::SDK::Trace::Span::Exporter::Console;

our $VERSION = '0.001';

class OpenTelemetry::SDK::Trace::Span::Exporter::Console :does(OpenTelemetry::SDK::Trace::Span::Exporter) {
    use Future::AsyncAwait;

    use OpenTelemetry::Trace qw(
        EXPORT_FAILURE
        EXPORT_SUCCESS
    );

    has $stopped;

    async method export (%args) {
        return EXPORT_FAILURE if $stopped;

        require Data::Dumper;
        local $Data::Dumper::Indent = 0;
        local $Data::Dumper::Terse  = 1;

        Data::Dumper::Dumper($_) for @{ $args{spans} // [] };

        EXPORT_SUCCESS;
    }

    async method shutdown ( $timeout = undef ) { $stopped = 1; EXPORT_SUCCESS }

    async method force_flush ( $timeout = undef ) { EXPORT_SUCCESS }
}